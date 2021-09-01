package("urdfdom")

    set_homepage("https://wiki.ros.org/urdf")
    set_description("A C++ parser for the Unified Robot Description Format (URDF)")
    set_license("BSD-3-Clause")

    add_urls("https://github.com/ros/urdfdom/archive/refs/tags/$(version).tar.gz",
             "https://github.com/ros/urdfdom.git")
    add_versions("1.0.4", "8f3d56b0cbc4b84436d8baf4c8346cd2ee7ffb257bba5ddd9892c41bf516edc4")

    add_patches("1.0.4", path.join(os.scriptdir(), "patches", "1.0.4", "build.patch"), "1f51148afccef7b9bf079ef4137c12d578fb7a76f7aed6e282ca2ceaf4a188ba")

    add_deps("cmake")
    add_deps("urdfdom-headers", "console-bridge", "tinyxml")
    on_install("windows", "linux", "macosx", function (package)
        local configs = {"-DCMAKE_INSTALL_LIBDIR=lib"} 
        table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:debug() and "Debug" or "Release"))
        table.insert(configs, "-DBUILD_SHARED_LIBS=" .. (package:config("shared") and "ON" or "OFF"))
        import("package.tools.cmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [[
            #include <string>
            void test() {
                std::string easy{"1.0"};
                double conv = urdf::strToDouble(easy.c_str());
            }
        ]]}, {configs = {languages = "c++11"}, includes = "urdf_model/utils.h"}))
    end)
