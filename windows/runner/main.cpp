#ifndef WIN32_LEAN_AND_MEAN
#define WIN32_LEAN_AND_MEAN
#endif

#include <winsock2.h>
#include <ws2tcpip.h>
#include <windows.h>
#include <delayimp.h>

#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>

#include "flutter_window.h"
#include "utils.h"

// Polyfill function for Windows 7 where GetHostNameW is missing in WS2_32.dll
static int WSAAPI FallbackGetHostNameW(PWSTR name, int namelen) {
  if (!name || namelen <= 0) return SOCKET_ERROR;
  DWORD size = static_cast<DWORD>(namelen);
  if (GetComputerNameExW(ComputerNameDnsHostname, name, &size)) {
    return 0;
  }
  char buffer[256] = {0};
  if (gethostname(buffer, sizeof(buffer)) == 0) {
    int res = MultiByteToWideChar(CP_ACP, 0, buffer, -1, name, namelen);
    if (res > 0) return 0;
  }
  return SOCKET_ERROR;
}

// Delay load failure hook to catch missing GetHostNameW on Windows 7
static FARPROC WINAPI DelayLoadFailureHook(unsigned dliNotify, PDelayLoadInfo pdli) {
  if (dliNotify == dliFailGetProc) {
    if (pdli->dlp.fImportByName && pdli->dlp.szProcName &&
        strcmp(pdli->dlp.szProcName, "GetHostNameW") == 0) {
      return (FARPROC)FallbackGetHostNameW;
    }
  }
  return NULL;
}

extern "C" {
  const PfnDliHook __pfnDliFailureHook2 = DelayLoadFailureHook;
}

int APIENTRY wWinMain(_In_ HINSTANCE instance, _In_opt_ HINSTANCE prev,
                      _In_ wchar_t *command_line, _In_ int show_command) {
  // Attach to console when present (e.g., 'flutter run') or create a
  // new console when running with a debugger.
  if (!::AttachConsole(ATTACH_PARENT_PROCESS) && ::IsDebuggerPresent()) {
    CreateAndAttachConsole();
  }

  // Initialize COM, so that it is available for use in the library and/or
  // plugins.
  ::CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED);

  flutter::DartProject project(L"data");

  std::vector<std::string> command_line_arguments =
      GetCommandLineArguments();

  project.set_dart_entrypoint_arguments(std::move(command_line_arguments));

  FlutterWindow window(project);
  Win32Window::Point origin(10, 10);
  Win32Window::Size size(1280, 720);
  if (!window.Create(L"Rukmini Jewellers", origin, size)) {
    return EXIT_FAILURE;
  }
  window.SetQuitOnClose(true);

  ::MSG msg;
  while (::GetMessage(&msg, nullptr, 0, 0)) {
    ::TranslateMessage(&msg);
    ::DispatchMessage(&msg);
  }

  ::CoUninitialize();
  return EXIT_SUCCESS;
}
