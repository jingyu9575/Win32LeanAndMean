#include <cstddef>
#include "obj/Win32LeanAndMean.hpp"

namespace wlm = Win32LeanAndMean;

static wlm::TCHAR szWindowClass[] = L"win32app";
static wlm::TCHAR szTitle[] = L"Win32 Guided Tour Application";

wlm::HINSTANCE hInst;

wlm::LRESULT __stdcall WndProc(wlm::HWND, wlm::UINT, wlm::WPARAM, wlm::LPARAM);

int __stdcall WinMain(wlm::HINSTANCE hInstance, wlm::HINSTANCE hPrevInstance,
	wlm::LPSTR lpCmdLine, int nCmdShow)
{
	wlm::WNDCLASSEX wcex;

	wcex.cbSize = sizeof(wlm::WNDCLASSEX);
	wcex.style = wlm::cs_hredraw | wlm::cs_vredraw;
	wcex.lpfnWndProc = WndProc;
	wcex.cbClsExtra = 0;
	wcex.cbWndExtra = 0;
	wcex.hInstance = hInstance;
	wcex.hIcon = wlm::LoadIconW(NULL, wlm::makeIntResource(wlm::idi_information));
	wcex.hCursor = wlm::LoadCursorW(NULL, wlm::idc_arrow);
	wcex.hbrBackground = (wlm::HBRUSH) (wlm::color_window + 1);
	wcex.lpszMenuName = NULL;
	wcex.lpszClassName = szWindowClass;
	wcex.hIconSm = wlm::LoadIconW(NULL, wlm::makeIntResource(wlm::idi_information));

	if (!RegisterClassExW(&wcex)) {
		wlm::MessageBoxW(NULL, L"Call to RegisterClassEx failed!",
			L"Win32 Guided Tour", 0);
		return 1;
	}

	hInst = hInstance;
	wlm::HWND hWnd = CreateWindowExW(0, szWindowClass, szTitle,
		wlm::ws_overlappedwindow, wlm::cw_usedefault, wlm::cw_usedefault,
		500, 100, NULL, NULL, hInstance, NULL);

	if (!hWnd) {
		wlm::MessageBoxW(NULL, L"Call to CreateWindow failed!",
			L"Win32 Guided Tour", 0);
		return 1;
	}

	ShowWindow(hWnd, nCmdShow);
	UpdateWindow(hWnd);

	wlm::MSG msg;
	while (wlm::GetMessageW(&msg, NULL, 0, 0)) {
		wlm::TranslateMessage(&msg);
		wlm::DispatchMessageW(&msg);
	}

	return (int) msg.wParam;
}

wlm::LRESULT __stdcall WndProc(wlm::HWND hWnd, wlm::UINT message, wlm::WPARAM wParam, wlm::LPARAM lParam)
{
	wlm::PAINTSTRUCT ps;
	wlm::HDC hdc;
	wlm::TCHAR greeting[] = L"Hello, World!";

	switch (message) {
	case wlm::wm_paint:
		hdc = BeginPaint(hWnd, &ps);

		TextOutW(hdc, 5, 5, greeting, wlm::wcslen(greeting));

		EndPaint(hWnd, &ps);
		break;
	case wlm::wm_destroy:
		wlm::PostQuitMessage(0);
		break;
	default:
		return wlm::DefWindowProcW(hWnd, message, wParam, lParam);
		break;
	}

	return 0;
}
