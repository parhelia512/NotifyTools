cmake_minimum_required(VERSION 3.13) # CMake version check
project(imgui) # Create project "imgui"
set(CMAKE_CXX_STANDARD 20) # Enable c++14 standard
set(CMAKE_EXPORT_COMPILE_COMMANDS TRUE)

#纠缠的WIN VS UTF8 GBK
add_compile_options("$<$<C_COMPILER_ID:MSVC>:/utf-8>")
add_compile_options("$<$<CXX_COMPILER_ID:MSVC>:/utf-8>")
#add_compile_options("$<$<C_COMPILER_ID:MSVC>: /Zc:char8_t->")
#add_compile_options("$<$<CXX_COMPILER_ID:MSVC>:/Zc:char8_t->")
#add_compile_options("$<$<CXX_COMPILER_ID:MSVC>:/source-charset:utf-8>")
#add_compile_options("$<$<CXX_COMPILER_ID:MSVC>:/execution-charset:utf-8>")

#add_compile_options("$<$<C_COMPILER_ID:MSVC>:/std:c++latest>")
#add_compile_options("$<$<CXX_COMPILER_ID:MSVC>:/std:c++latest>")
# You may have to manually set CMAKE_C_COMPILER and CMAKE_CXX_COMPILER
# respectively to clang set(CMAKE_C_COMPILER "/usr/local/bin/clang")
# set(CMAKE_CXX_COMPILER "/usr/local/bin/clang++")


#文件转c
#https://tisyang.github.io/post/2021-01-25-embed-assets-using-cmake/
# 需要生成嵌入的文件
file (GLOB EMBED_FILES
    "${CMAKE_CURRENT_SOURCE_DIR}/examples/example_sdl2_sdlrenderer/*.yaml"
)
# 输出文件目录
set (GEN_EMBED_OUTPUT_HDR_DIR
    "${CMAKE_CURRENT_SOURCE_DIR}/examples/example_sdl2_sdlrenderer/")
set (GEN_EMBED_OUTPUT_SRC_DIR
     "${CMAKE_CURRENT_SOURCE_DIR}/examples/example_sdl2_sdlrenderer/")
file(MAKE_DIRECTORY ${GEN_EMBED_OUTPUT_HDR_DIR})
file(MAKE_DIRECTORY ${GEN_EMBED_OUTPUT_SRC_DIR})

# 依次处理文件
foreach(input_src ${EMBED_FILES})
    # 配置输出文件名
    file(SIZE ${input_src} embed_file_size)
    get_filename_component(embed_file ${input_src} NAME)
    set(gen_embed_file        "${GEN_EMBED_OUTPUT_SRC_DIR}/${embed_file}.cpp")
    set(gen_embed_file_header "${GEN_EMBED_OUTPUT_HDR_DIR}/${embed_file}.h")
   
    # 清空输出文件
    file(WRITE ${gen_embed_file} "")
    file(WRITE ${gen_embed_file_header} "")
    # for c compatibility
    string(MAKE_C_IDENTIFIER ${embed_file} token)
    # to upper case
    string(TOUPPER ${token} token)
    # read hex data from file
    file(READ ${input_src} filedata HEX)
    # convert hex data for C compatibility
    string(REGEX REPLACE "([0-9a-f][0-9a-f])" "0x\\1," filedata ${filedata})
    # append data to output file
    file(APPEND ${gen_embed_file}
        "extern const unsigned char ${token}__DATA[] = {\n${filedata}0x00\n};\n"
        "extern const unsigned long ${token}__SIZE   = ${embed_file_size};\n")
    file(APPEND ${gen_embed_file_header}
        "extern const unsigned char ${token}__DATA[];\n"
        "extern const unsigned long ${token}__SIZE;\n")
    # 加入到生成文件列表
    list(APPEND GEN_EMBED_FILES
        ${gen_embed_file}
        ${gen_embed_file_header}
    )
endforeach()

add_custom_target(
    embed_gen_files
    DEPENDS ${GEN_EMBED_FILES}
)
 message(STATUS "GEN_EMBED_FILES ${GEN_EMBED_FILES}")

# Add all .cpp files of project root directory as source file
set(SOURCE_FILES imgui.cpp imgui_draw.cpp imgui_demo.cpp imgui_tables.cpp
                 imgui_widgets.cpp) # Add all .cpp files of project root
                                    # directory as source files

option(BUILD_SHARED_LIBS "Build using shared libraries" OFF)

set(SDL2_DIR "../../../SDL2-2.0.22/build/inst/cmake")
message(STATUS "sdl2_dir ${SDL2_DIR}")
find_package(SDL2 REQUIRED SDL2)
if(SDL2_FOUND)
  message(STATUS "SDL2 ${SDL2_INCLUDE_DIRS} ${SDL2_LIBRARIES}")
else()
  message(FATAL_ERROR "SDL2 library not found")
endif()

set(yaml-cpp_DIR "../../../yaml-cpp/builddll/inst/share/cmake/yaml-cpp")
find_package(yaml-cpp REQUIRED)
if(yaml-cpp_FOUND)
  message(STATUS "YAML_CPP ${YAML_CPP_INCLUDE_DIR} ${YAML_CPP_LIBRARIES}")
else()
  message(FATAL_ERROR "YAML_CPP library not found")
endif()

# Add library target with source files listed in SOURCE_FILES variable
add_library(imgui ${SOURCE_FILES})

option(BUILD_BACKEND_ALLEGRO5 "Build backend allegro5" OFF)
option(BUILD_BACKEND_ANDROID "Build backend android" OFF)
option(BUILD_BACKEND_DX_9 "Build backend directX 9" OFF)
option(BUILD_BACKEND_DX_10 "Build backend directX 10" OFF)
option(BUILD_BACKEND_DX_11 "Build backend directX 11" OFF)
option(BUILD_BACKEND_DX_12 "Build backend directX 12" OFF)
option(BUILD_BACKEND_GLFW "Build backend GLFW" OFF)
option(BUILD_BACKEND_GLUT "Build backend GLUT" OFF)
option(BUILD_BACKEND_METAL "Build backend METAL" OFF)
option(BUILD_BACKEND_OPENGL_2 "Build backend OPENGL 2" OFF)
option(BUILD_BACKEND_OPENGL_3 "Build backend OPENGL 3" OFF)
option(BUILD_BACKEND_OSX "Build backend OSX / Cocoa" OFF)
option(BUILD_BACKEND_SDL "Build backend SDL" ON)
option(BUILD_BACKEND_VULKAN "Build backend VULKAN" OFF)
option(BUILD_BACKEND_WEBGPU "Build backend WEBGPU" OFF)
option(BUILD_BACKEND_WIN32 "Build backend WIN32" OFF)

include_directories(./)
# Add library target with source files listed under backends folder
if(${BUILD_BACKEND_ALLEGRO5})
  set(BACKEND_FILE ./backends/imgui_impl_allegro5.cpp)
  add_library(imgui_backend_allegro5 ${BACKEND_FILE})
endif()
if(${BUILD_BACKEND_ANDROID})
  set(BACKEND_FILE ./backends/imgui_impl_android.cpp)
  add_library(imgui_backend_android ${BACKEND_FILE})
endif()
if(${BUILD_BACKEND_DX_9})
  set(BACKEND_FILE ./backends/imgui_impl_dx9.cpp)
  add_library(imgui_backend_dx9 ${BACKEND_FILE})
endif()
if(${BUILD_BACKEND_DX_10})
  set(BACKEND_FILE ./backends/imgui_impl_dx10.cpp)
  add_library(imgui_backend_dx10 ${BACKEND_FILE})
endif()
if(${BUILD_BACKEND_DX_11})
  set(BACKEND_FILE ./backends/imgui_impl_dx11.cpp)
  add_library(imgui_backend_dx11 ${BACKEND_FILE})
endif()
if(${BUILD_BACKEND_DX_12})
  set(BACKEND_FILE ./backends/imgui_impl_dx12.cpp)
  add_library(imgui_backend_dx12 ${BACKEND_FILE})
endif()
if(${BUILD_BACKEND_GLFW})
  set(BACKEND_FILE ./backends/imgui_impl_glfw.cpp)
  add_library(imgui_backend_glfw ${BACKEND_FILE})
endif()
if(${BUILD_BACKEND_GLUT})
  set(BACKEND_FILE ./backends/imgui_impl_glut.cpp)
  add_library(imgui_backend_glut ${BACKEND_FILE})
endif()
if(${BUILD_BACKEND_METAL})
  set(BACKEND_FILE ./backends/imgui_impl_metal.mm)
  add_library(imgui_backend_metal ${BACKEND_FILE})
endif()
if(${BUILD_BACKEND_OPENGL_2})
  set(BACKEND_FILE ./backends/imgui_impl_opengl2.cpp)
  add_library(imgui_backend_opengl2 ${BACKEND_FILE})
endif()
if(${BUILD_BACKEND_OPENGL_3})
  set(BACKEND_FILE ./backends/imgui_impl_opengl3.cpp)
  add_library(imgui_backend_opengl3 ${BACKEND_FILE})
endif()
if(${BUILD_BACKEND_OSX})
  set(BACKEND_FILE ./backends/imgui_impl_osx.mm)
  add_library(imgui_backend_osx ${BACKEND_FILE})
endif()
if(${BUILD_BACKEND_SDL})
  set(BACKEND_FILE ./backends/imgui_impl_sdl2.cpp
                   ./backends/imgui_impl_sdlrenderer.cpp)
  add_library(imgui_backend_sdl2 ${BACKEND_FILE})
  target_include_directories(imgui_backend_sdl2 PRIVATE ${SDL2_INCLUDE_DIRS}
                                                        ${YAML_CPP_INCLUDE_DIR})
  target_link_libraries(imgui_backend_sdl2 imgui ${SDL2_LIBRARIES})
endif()
if(${BUILD_BACKEND_VULKAN})
  set(BACKEND_FILE ./backends/imgui_impl_vulkan.cpp)
  add_library(imgui_backend_vulkan ${BACKEND_FILE})
endif()
if(${BUILD_BACKEND_WEBGPU})
  set(BACKEND_FILE ./backends/imgui_impl_wgpu.cpp)
  add_library(imgui_backend_wgpu ${BACKEND_FILE})
endif()
if(${BUILD_BACKEND_WIN32})
  set(BACKEND_FILE ./backends/imgui_impl_win32.cpp)
  add_library(imgui_backend_win32 ${BACKEND_FILE})
endif()

option(BUILD_EXAMPLE_ALLEGRO5 "Build example allegro5" OFF)
option(BUILD_EXAMPLE_ANDROID_OPENGL3 "Build example android opengl 3" OFF)
option(BUILD_EXAMPLE_APPLE_METAL "Build example apple metal 9" OFF)
option(BUILD_EXAMPLE_APPLE_OPENGL2 "Build example apple opengl 2" OFF)
option(BUILD_EXAMPLE_EMSCRIPTEN_OPENGL3 "Build example emscripten opengl 3" OFF)
option(BUILD_EXAMPLE_EMSCRIPTEN_WGPU "Build example emscripten wgpu" OFF)
option(BUILD_EXAMPLE_GLFW_METAL "Build example glfw metal" OFF)
option(BUILD_EXAMPLE_GLFW_OPENGL2 "Build example glfw opengl 2" OFF)
option(BUILD_EXAMPLE_GLFW_OPENGL3 "Build example glfw opengl 3" OFF)
option(BUILD_EXAMPLE_GLFW_VULKAN "Build example glfw vulkan" OFF)
option(BUILD_EXAMPLE_GLUT_OPENGL2 "Build example glut opengl 2" OFF)
option(BUILD_EXAMPLE_NULL "Build example null" ON)
option(BUILD_EXAMPLE_SDL_DIRECTX11 "Build example SDL directx 11" OFF)
option(BUILD_EXAMPLE_SDL_METAL "Build example SDL metal" OFF)
option(BUILD_EXAMPLE_SDL_OPENGL2 "Build example SDL opengl 2" OFF)
option(BUILD_EXAMPLE_SDL_OPENGL3 "Build example SDL opengl 3" OFF)
option(BUILD_EXAMPLE_SDL_SDLRENDERER "Build example SDL SDLRenderer" ON)
option(BUILD_EXAMPLE_SDL_VULKAN "Build example SDL vulkan" OFF)
option(BUILD_EXAMPLE_WIN32_DIRECTX9 "Build example win32 directx 9" OFF)
option(BUILD_EXAMPLE_WIN32_DIRECTX10 "Build example win32 directx 10" OFF)
option(BUILD_EXAMPLE_WIN32_DIRECTX11 "Build example win32 directx 11" OFF)
option(BUILD_EXAMPLE_WIN32_DIRECTX12 "Build example win32 directx 12" OFF)

# find_package(allegro CONFIG REQUIRED) # for CMake packages
find_package(PkgConfig REQUIRED) # For .pc packages

include_directories(./backends)
if(${BUILD_EXAMPLE_ALLEGRO5})
  pkg_check_modules(ALLEGRO5 REQUIRED allegro-5 allegro_primitives-5)
  set(EXAMPLE_MAIN_FILE ./examples/example_allegro5/main.cpp)
  add_executable(example_allegro5 ${EXAMPLE_MAIN_FILE})
  target_link_libraries(example_allegro5 imgui imgui_backend_allegro5
                        ${ALLEGRO5_LIBRARIES})
endif()
if(${BUILD_EXAMPLE_ANDROID_OPENGL3})
  pkg_check_modules(OPENGL3 REQUIRED opengl)
  set(EXAMPLE_MAIN_FILE ./examples/example_android_opengl3/main.cpp)
  add_executable(example_android_opengl3 ${EXAMPLE_MAIN_FILE})
  target_link_libraries(example_android_opengl3 imgui imgui_backend_android
                        imgui_backend_opengl3 OpenGL)
endif()
if(${BUILD_EXAMPLE_APPLE_METAL})
  pkg_check_modules(METAL REQUIRED metal)
  set(EXAMPLE_MAIN_FILE ./examples/example_apple_metal/main.mm)
  add_executable(example_apple_metal ${EXAMPLE_MAIN_FILE})
  target_link_libraries(example_apple_metal imgui imgui_backend_osx
                        imgui_backend_metal)
endif()
if(${BUILD_EXAMPLE_APPLE_OPENGL2})
  pkg_check_modules(OPENGL2 REQUIRED opengl)
  set(EXAMPLE_MAIN_FILE ./examples/example_apple_opengl2/main.mm)
  add_executable(example_apple_opengl2 ${EXAMPLE_MAIN_FILE})
  target_link_libraries(example_apple_opengl2 imgui imgui_backend_osx
                        imgui_backend_opengl2)
endif()
if(${BUILD_EXAMPLE_EMSCRIPTEN_OPENGL3})
  pkg_check_modules(OPENGL3 REQUIRED opengl)
  set(EXAMPLE_MAIN_FILE ./examples/example_emscripten_opengl3/main.cpp)
  add_executable(example_emscripten_opengl3 ${EXAMPLE_MAIN_FILE})
  target_link_libraries(example_emscripten_opengl3 imgui imgui_backend_opengl3)
endif()
if(${BUILD_EXAMPLE_EMSCRIPTEN_WGPU})
  pkg_check_modules(WEBGPU REQUIRED webgpu)
  set(EXAMPLE_MAIN_FILE ./examples/example_emscripten_wgpu/main.cpp)
  add_executable(example_emscripten_wgpu ${EXAMPLE_MAIN_FILE})
  target_link_libraries(example_emscripten_wgpu imgui imgui_backend_wgpu)
endif()
if(${BUILD_EXAMPLE_GLFW_METAL})
  pkg_check_modules(GLFW REQUIRED glfw3)
  pkg_check_modules(METAL REQUIRED metal)
  set(EXAMPLE_MAIN_FILE ./examples/example_glfw_metal/main.mm)
  add_executable(example_glfw_metal ${EXAMPLE_MAIN_FILE})
  target_link_libraries(example_glfw_metal imgui imgui_backend_glfw
                        imgui_backend_metal glfw)
endif()
if(${BUILD_EXAMPLE_GLFW_OPENGL2})
  pkg_check_modules(GLFW REQUIRED glfw3)
  pkg_check_modules(OPENGL2 REQUIRED opengl)
  set(EXAMPLE_MAIN_FILE ./examples/example_glfw_opengl2/main.cpp)
  add_executable(example_glfw_opengl2 ${EXAMPLE_MAIN_FILE})
  target_link_libraries(example_glfw_opengl2 imgui imgui_backend_glfw
                        imgui_backend_opengl2 glfw OpenGL)
endif()
if(${BUILD_EXAMPLE_GLFW_OPENGL3})
  pkg_check_modules(GLFW REQUIRED glfw3)
  pkg_check_modules(OPENGL3 REQUIRED opengl)
  set(EXAMPLE_MAIN_FILE ./examples/example_glfw_opengl3/main.cpp)
  add_executable(example_glfw_opengl3 ${EXAMPLE_MAIN_FILE})
  target_link_libraries(example_glfw_opengl3 imgui imgui_backend_glfw
                        imgui_backend_opengl3 glfw OpenGL)
endif()
if(${BUILD_EXAMPLE_GLFW_VULKAN})
  pkg_check_modules(GLFW REQUIRED glfw3)
  pkg_check_modules(VULKAN REQUIRED vulkan)
  set(EXAMPLE_MAIN_FILE ./examples/example_glfw_vulkan/main.cpp)
  add_executable(example_glfw_vulkan ${EXAMPLE_MAIN_FILE})
  target_link_libraries(example_glfw_vulkan imgui imgui_backend_glfw
                        imgui_backend_vulkan glfw vulkan)
endif()
if(${BUILD_EXAMPLE_GLUT_OPENGL2})
  pkg_check_modules(GLUT REQUIRED glut)
  pkg_check_modules(OPENGL2 REQUIRED opengl)
  set(EXAMPLE_MAIN_FILE ./examples/example_glut_opengl2/main.cpp)
  add_executable(example_glut_opengl2 ${EXAMPLE_MAIN_FILE})
  target_link_libraries(example_glut_opengl2 imgui imgui_backend_glut
                        imgui_backend_opengl2 glut OpenGL)
endif()
if(${BUILD_EXAMPLE_NULL})
  set(EXAMPLE_MAIN_FILE ./examples/example_null/main.cpp)
  add_executable(example_null ${EXAMPLE_MAIN_FILE})
  target_link_libraries(example_null imgui)
endif()
if(${BUILD_EXAMPLE_SDL_DIRECTX11})
  pkg_check_modules(SDL2 REQUIRED sdl2)
  pkg_check_modules(DX11 REQUIRED dx11)
  set(EXAMPLE_MAIN_FILE ./examples/example_sdl_directx11/main.cpp)
  add_executable(example_sdl_directx11 ${EXAMPLE_MAIN_FILE})
  target_link_libraries(example_sdl_directx11 imgui imgui_backend_sdl
                        imgui_backend_dx11 ${SDL2_LIBRARIES} ${DX11_LIBRARIES})
endif()
if(${BUILD_EXAMPLE_SDL_METAL})
  pkg_check_modules(SDL2 REQUIRED sdl2)
  set(EXAMPLE_MAIN_FILE ./examples/example_sdl_metal/main.cpp)
  add_executable(example_sdl_metal ${EXAMPLE_MAIN_FILE})
  target_link_libraries(example_sdl_metal imgui imgui_backend_sdl
                        imgui_backend_metal ${SDL2_LIBRARIES})
endif()
if(${BUILD_EXAMPLE_SDL_OPENGL2})
  pkg_check_modules(SDL2 REQUIRED sdl2)
  pkg_check_modules(OPENGL2 REQUIRED opengl)
  set(EXAMPLE_MAIN_FILE ./examples/example_sdl_opengl2/main.cpp)
  add_executable(example_sdl_opengl2 ${EXAMPLE_MAIN_FILE})
  target_link_libraries(
    example_sdl_opengl2 imgui imgui_backend_sdl imgui_backend_opengl2
    ${SDL2_LIBRARIES} ${OPENGL2_LIBRARIES})
endif()
if(${BUILD_EXAMPLE_SDL_OPENGL3})
  pkg_check_modules(SDL2 REQUIRED sdl2)
  pkg_check_modules(OPENGL3 REQUIRED opengl)
  set(EXAMPLE_MAIN_FILE ./examples/example_sdl_opengl3/main.cpp)
  add_executable(example_sdl_opengl3 ${EXAMPLE_MAIN_FILE})
  target_link_libraries(
    example_sdl_opengl3 imgui imgui_backend_sdl imgui_backend_opengl3
    ${SDL2_LIBRARIES} ${OPENGL3_LIBRARIES})
endif()
if(${BUILD_EXAMPLE_SDL_SDLRENDERER})

  set(EXAMPLE_MAIN_FILE ./examples/example_sdl2_sdlrenderer/main.cpp)
  add_executable(example_sdl2_sdlrenderer ${EXAMPLE_MAIN_FILE}  ${GEN_EMBED_FILES})
  add_dependencies(example_sdl2_sdlrenderer embed_gen_files)
  target_include_directories(
    example_sdl2_sdlrenderer PRIVATE ${SDL2_INCLUDE_DIRS}
                                     ${YAML_CPP_INCLUDE_DIR})
  target_link_libraries(example_sdl2_sdlrenderer imgui imgui_backend_sdl2
                        ${SDL2_LIBRARIES} ${YAML_CPP_LIBRARIES})
endif()
if(${BUILD_EXAMPLE_SDL_VULKAN})
  pkg_check_modules(SDL2 REQUIRED sdl2)
  pkg_check_modules(VULKAN REQUIRED vulkan)
  set(EXAMPLE_MAIN_FILE ./examples/example_sdl_vulkan/main.cpp)
  add_executable(example_sdl_vulkan ${EXAMPLE_MAIN_FILE})
  target_link_libraries(example_sdl_vulkan imgui imgui_backend_sdl
                        imgui_backend_vulkan ${SDL2_LIBRARIES} vulkan)
endif()
if(${BUILD_EXAMPLE_WIN32_DIRECTX9})
  pkg_check_modules(DX9 REQUIRED dx9)
  set(EXAMPLE_MAIN_FILE ./examples/example_win32_directx9/main.cpp)
  add_executable(example_win32_directx9 ${EXAMPLE_MAIN_FILE})
  target_link_libraries(example_win32_directx9 imgui imgui_backend_dx9)
endif()
if(${BUILD_EXAMPLE_WIN32_DIRECTX10})
  pkg_check_modules(DX10 REQUIRED dx10)
  set(EXAMPLE_MAIN_FILE ./examples/example_win32_directx10/main.cpp)
  add_executable(example_win32_directx10 ${EXAMPLE_MAIN_FILE})
  target_link_libraries(example_win32_directx10 imgui imgui_backend_dx10)
endif()
if(${BUILD_EXAMPLE_WIN32_DIRECTX11})
  pkg_check_modules(DX11 REQUIRED dx11)
  set(EXAMPLE_MAIN_FILE ./examples/example_win32_directx11/main.cpp)
  add_executable(example_win32_directx11 ${EXAMPLE_MAIN_FILE})
  target_link_libraries(example_win32_directx11 imgui imgui_backend_dx11)
endif()
if(${BUILD_EXAMPLE_WIN32_DIRECTX12})
  pkg_check_modules(DX12 REQUIRED dx12)
  set(EXAMPLE_MAIN_FILE ./examples/example_win32_directx12/main.cpp)
  add_executable(example_win32_directx12 ${EXAMPLE_MAIN_FILE})
  target_link_libraries(example_win32_directx12 imgui imgui_backend_dx12)
endif()
