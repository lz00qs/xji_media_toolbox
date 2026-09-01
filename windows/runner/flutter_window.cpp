#include "flutter_window.h"

#include <shobjidl.h>

#include <optional>
#include <string>

#include <flutter/standard_method_codec.h>

#include "flutter/generated_plugin_registrant.h"

namespace {

constexpr char kFileTrashChannelName[] = "xji_footage_toolbox/file_trash";

std::wstring Utf16FromUtf8(const std::string& value) {
  if (value.empty()) {
    return std::wstring();
  }
  const int length = ::MultiByteToWideChar(
      CP_UTF8, MB_ERR_INVALID_CHARS, value.data(),
      static_cast<int>(value.size()), nullptr, 0);
  if (length <= 0) {
    return std::wstring();
  }
  std::wstring converted(length, L'\0');
  if (::MultiByteToWideChar(
          CP_UTF8, MB_ERR_INVALID_CHARS, value.data(),
          static_cast<int>(value.size()), converted.data(), length) == 0) {
    return std::wstring();
  }
  return converted;
}

HRESULT MoveFileToRecycleBin(const std::wstring& path, HWND owner) {
  IFileOperation* operation = nullptr;
  HRESULT result = ::CoCreateInstance(
      CLSID_FileOperation, nullptr, CLSCTX_INPROC_SERVER,
      IID_PPV_ARGS(&operation));
  if (FAILED(result)) {
    return result;
  }

  result = operation->SetOwnerWindow(owner);
  if (SUCCEEDED(result)) {
    result = operation->SetOperationFlags(
        FOF_NOCONFIRMATION | FOF_NOERRORUI | FOF_SILENT |
        FOFX_EARLYFAILURE | FOFX_RECYCLEONDELETE);
  }

  IShellItem* item = nullptr;
  if (SUCCEEDED(result)) {
    result = ::SHCreateItemFromParsingName(
        path.c_str(), nullptr, IID_PPV_ARGS(&item));
  }
  if (SUCCEEDED(result)) {
    result = operation->DeleteItem(item, nullptr);
  }
  if (item != nullptr) {
    item->Release();
  }

  if (SUCCEEDED(result)) {
    result = operation->PerformOperations();
  }
  if (SUCCEEDED(result)) {
    BOOL aborted = FALSE;
    result = operation->GetAnyOperationsAborted(&aborted);
    if (SUCCEEDED(result) && aborted) {
      result = HRESULT_FROM_WIN32(ERROR_CANCELLED);
    }
  }

  operation->Release();
  return result;
}

}  // namespace

FlutterWindow::FlutterWindow(const flutter::DartProject& project)
    : project_(project) {}

FlutterWindow::~FlutterWindow() {}

bool FlutterWindow::OnCreate() {
  if (!Win32Window::OnCreate()) {
    return false;
  }

  RECT frame = GetClientArea();

  // The size here must match the window dimensions to avoid unnecessary surface
  // creation / destruction in the startup path.
  flutter_controller_ = std::make_unique<flutter::FlutterViewController>(
      frame.right - frame.left, frame.bottom - frame.top, project_);
  // Ensure that basic setup of the controller was successful.
  if (!flutter_controller_->engine() || !flutter_controller_->view()) {
    return false;
  }
  RegisterPlugins(flutter_controller_->engine());
  file_trash_channel_ =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          flutter_controller_->engine()->messenger(), kFileTrashChannelName,
          &flutter::StandardMethodCodec::GetInstance());
  file_trash_channel_->SetMethodCallHandler(
      [this](const flutter::MethodCall<flutter::EncodableValue>& call,
             std::unique_ptr<
                 flutter::MethodResult<flutter::EncodableValue>> result) {
        if (call.method_name() != "moveToTrash") {
          result->NotImplemented();
          return;
        }

        const auto* arguments =
            std::get_if<flutter::EncodableMap>(call.arguments());
        if (arguments == nullptr) {
          result->Error("invalid_path", "A file path is required.");
          return;
        }
        const auto path_it =
            arguments->find(flutter::EncodableValue("path"));
        if (path_it == arguments->end()) {
          result->Error("invalid_path", "A file path is required.");
          return;
        }
        const auto* path = std::get_if<std::string>(&path_it->second);
        if (path == nullptr || path->empty()) {
          result->Error("invalid_path", "A non-empty file path is required.");
          return;
        }

        const std::wstring wide_path = Utf16FromUtf8(*path);
        if (wide_path.empty()) {
          result->Error("invalid_path", "The file path is not valid UTF-8.");
          return;
        }
        const HRESULT trash_result =
            MoveFileToRecycleBin(wide_path, GetHandle());
        if (FAILED(trash_result)) {
          result->Error(
              "trash_failed", "Failed to move the file to the Recycle Bin.",
              flutter::EncodableValue(static_cast<int64_t>(trash_result)));
          return;
        }
        result->Success();
      });
  SetChildContent(flutter_controller_->view()->GetNativeWindow());

  flutter_controller_->engine()->SetNextFrameCallback([&]() {
    this->Show();
  });

  // Flutter can complete the first frame before the "show window" callback is
  // registered. The following call ensures a frame is pending to ensure the
  // window is shown. It is a no-op if the first frame hasn't completed yet.
  flutter_controller_->ForceRedraw();

  return true;
}

void FlutterWindow::OnDestroy() {
  file_trash_channel_.reset();
  if (flutter_controller_) {
    flutter_controller_ = nullptr;
  }

  Win32Window::OnDestroy();
}

LRESULT
FlutterWindow::MessageHandler(HWND hwnd, UINT const message,
                              WPARAM const wparam,
                              LPARAM const lparam) noexcept {
  // Give Flutter, including plugins, an opportunity to handle window messages.
  if (flutter_controller_) {
    std::optional<LRESULT> result =
        flutter_controller_->HandleTopLevelWindowProc(hwnd, message, wparam,
                                                      lparam);
    if (result) {
      return *result;
    }
  }

  switch (message) {
    case WM_FONTCHANGE:
      flutter_controller_->engine()->ReloadSystemFonts();
      break;
  }

  return Win32Window::MessageHandler(hwnd, message, wparam, lparam);
}
