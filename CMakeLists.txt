cmake_minimum_required(VERSION 3.16)

project(HKVentil VERSION 1.0 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.2 COMPONENTS Quick REQUIRED)
find_package(Qt6 REQUIRED COMPONENTS Svg)       # necessary for android


# on windows set app icon
set(app_icon_resource_windows "${CMAKE_CURRENT_SOURCE_DIR}/resources/iconapp.rc")


qt_add_executable(appHKVentil
    main.cpp
    ClassHeatCalculator.cpp
    ClassHeatCalculator.h
    images.qrc
    ${app_icon_resource_windows}
)

qt_add_qml_module(appHKVentil
    URI HKVentil
    VERSION 1.0
    QML_FILES
        main.qml
        HeatPage.qml
        HeatCurve.qml
        #ValvePage.qml
        #ResultPage.qml
        PumpPage.qml
        FFormula.qml
        FSpinBox.qml
        FButton.qml
        FGButton.qml
        FGSlider.qml
        FGSpinBox.qml
        FGCheckBox.qml
        FCurveSettings.qml

)

set_target_properties(appHKVentil PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER my.example.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appHKVentil
    PRIVATE Qt6::Quick
    PRIVATE  Qt6::Svg)

install(TARGETS appHKVentil
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})
