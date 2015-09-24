@echo off
mkdir Win32LeanAndMean_tmp 2>nul
pushd Win32LeanAndMean_tmp
set in=in.c
set out=..\Win32LeanAndMean.hpp

>%in% echo #define UNICODE
>>%in% echo #define _UNICODE
>>%in% echo #define WIN32_LEAN_AND_MEAN
>>%in% echo #define _INC_STDLIB
>>%in% echo #include ^<Windows.h^>

cd.>%out%
>>%out% echo /*
>>%out% echo Auto-generated from MinGW w32api with a MIT style license:
>>%out% echo,
>>%out% echo Copyright (c) 2012 MinGW.org project
>>%out% echo,
>>%out% echo Permission is hereby granted, free of charge, to any person obtaining a
>>%out% echo copy of this software and associated documentation files (the "Software"),
>>%out% echo to deal in the Software without restriction, including without limitation
>>%out% echo the rights to use, copy, modify, merge, publish, distribute, sublicense,
>>%out% echo and/or sell copies of the Software, and to permit persons to whom the
>>%out% echo Software is furnished to do so, subject to the following conditions:
>>%out% echo,
>>%out% echo The above copyright notice, this permission notice and the below disclaimer
>>%out% echo shall be included in all copies or substantial portions of the Software.
>>%out% echo,
>>%out% echo THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
>>%out% echo IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
>>%out% echo FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
>>%out% echo AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
>>%out% echo LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
>>%out% echo FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
>>%out% echo DEALINGS IN THE SOFTWARE.
>>%out% echo */
>>%out% echo #pragma comment(lib, "kernel32")
>>%out% echo #pragma comment(lib, "user32")
>>%out% echo #pragma comment(lib, "gdi32")
>>%out% echo #pragma comment(lib, "winspool")
>>%out% echo #pragma comment(lib, "comdlg32")
>>%out% echo #pragma comment(lib, "advapi32")
>>%out% echo #pragma comment(lib, "shell32")
>>%out% echo #pragma comment(lib, "ole32")
>>%out% echo #pragma comment(lib, "oleaut32")
>>%out% echo #pragma comment(lib, "uuid")
>>%out% echo #pragma comment(lib, "odbc32")
>>%out% echo #pragma comment(lib, "odbccp32")
>>%out% echo #include ^<cstdarg^>
>>%out% echo namespace Win32LeanAndMean {
>>%out% echo #ifdef _MSC_VER
>>%out% echo #pragma warning(push)
>>%out% echo #pragma warning(disable : 4200)
>>%out% echo #endif

>>%out% echo #ifdef _WIN64
call :run 64
>>%out% echo #else
call :run 32
>>%out% echo #endif
>>%out% echo #ifdef _MSC_VER
>>%out% echo #pragma warning(pop)
>>%out% echo #endif
>>%out% echo }

del %in%

popd
rmdir Win32LeanAndMean_tmp

exit /b

:run

>>%out% echo extern "C" {
gcc -m%1 -E -P %in% -o expanded.c

set "stdcall="
if "%1"=="32" set stdcall=__stdcall
cproto -T expanded.c | ssed -R "/__gnuc_va_list/d;/typedef [a-zA-Z_ ]+wchar_t\;/d;s/__extension__//g;s/\( \*([a-zA-Z0-9_]+)\)/\(%stdcall% \*\1\)/g" >>%out%

ctags --fields=S -o tags.tmp --c-kinds=p expanded.c
ssed -n -R "s/^([a-zA-Z0-9_]+)\t\S+\t\/\^([^$]+?)\1[^$]+\$\/\;\x22\s*signature:(.*)$/\2\1\3\;/p" tags.tmp | ssed -R "s/__extension__//g;s/__attribute__\(\(__cdecl__\)\)/__cdecl/g;s/__attribute__\(\(__stdcall__\)\)/%stdcall%/g;s/__attribute__ ?\(\(_?_?dllimport_?_?\)\)//g;s/__attribute__\(\(noreturn\)\)/__declspec\(noreturn\)/g;s/__restrict__/__restrict/g" >> %out%

>>%out% echo }
>>%out% echo inline auto makeIntResource(UINT_PTR i) {return ((LPTSTR)((ULONG_PTR)(static_cast^<WORD^>(i))));}
>>%out% echo inline auto makeIntResource(void* i) {return makeIntResource((UINT_PTR)(i));}
>>%out% echo extern "C" {

gcc -m%1 -dM -E %in% -o def.tmp
ssed -i".bak" -R "/^#define __STDC/d;/^#define _?_?MINGW/d;/^#define DECLSPEC_CACHEALIGN/d;/^#define __DEC/d;/^#define __LDBL/d;/^#define __stdcall/d;s/^#define (FALSE|TRUE|DELETE|MOUSE_EVENT) /#define \1_ /g" def.tmp
del def.tmp.bak
ssed -n -R "s/^#define ([a-zA-Z0-9_]+) .*$/\1/p" def.tmp >name.tmp
cat def.tmp name.tmp > def.c

gcc -m%1 -E -P def.c -o def.tmp
paste -d" " name.tmp def.tmp | ssed -n -R "s/^([A-Z0-9_]+) ((?!{).*[0-9].*(?<!}))$/static const auto \L\1\E = \2;/p" | ssed -R "s/__MINGW_NAME_AW\(MAKEINTRESOURCE\)/makeIntResource/g;/[^a-zA-Z0-9_]defined[^a-zA-Z0-9_]/d;/\(void\)0/d;/__MINGW_NAME_UAW_EXT/d;s/LongToHandle/\(HANDLE\)\(LONG_PTR\)/g;/__pic__/d" >>%out%

del tags.tmp Trace.out name.tmp def.c def.tmp expanded.c

>>%out% echo }

exit /b