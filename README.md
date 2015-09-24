# Win32LeanAndMean

C++14 `<Windows.h>` without macros.

[Download the header](../../releases)

## About

This project generates a C++14 header "Win32LeanAndMean.hpp" from MinGW w32api, including the Win32 API declarations in `<Windows.h>` with `WIN32_LEAN_AND_MEAN` defined:

* typedefs, e.g. `HWND`
* structs, e.g. `WNDCLASSEX`
* functions, e.g. `MessageBoxW`
* constant macros converted to `static const`, in lower_case to avoid collision with `<Windows.h>` macros, e.g. `color_window`
* `#pragma comment(lib, "Win32 libs")`
 
Everything is in namespace `Win32LeanAndMean`. No new macros are defined, except those included in `<cstdarg>`.

Tested on cl (Visual Studio 2015), g++ (MinGW 6.0.0 20150520) and clang++ (LLVM 3.7.0svn-r234109), 32-bit and 64-bit build.
