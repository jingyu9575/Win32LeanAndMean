obj/test.exe: test.cpp obj/Win32LeanAndMean.hpp
	g++ -mwindows -std=c++14 $< -o $@ -lgdi32

obj/Win32LeanAndMean.hpp: Win32LeanAndMean.bat
	md obj 2>nul & cd obj && "../Win32LeanAndMean.bat"

clean:
	rd /s /q obj