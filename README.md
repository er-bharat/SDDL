# SDDL
SDDL is a lock screen inspired by SDDM for wlroot based wayland compositors. it dont use SDDM themes so dont try to use them you can edit to make the theme in qml and use with -c argument.

![screen-2025-07-05-11-34-55](https://github.com/user-attachments/assets/d92957ce-c8af-440f-8c77-4febf4b00844)


## run instructions
`./SDDL` to run or just click on it in build folder
`./SDDL -c path to theme.qml`     //for using a theme


## build
`
cmake -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build
`

