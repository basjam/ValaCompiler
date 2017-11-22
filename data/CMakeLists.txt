include (Translations)

include (GSettings)
add_schema (com.github.basjam.ValaCompiler.gschema.xml)

# install our .desktop file so the Applications menu will see it
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/com.github.basjam.ValaCompiler.desktop DESTINATION ${DATADIR}/applications/)

# install our .appdata.xml file so AppCenter will see it
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/com.github.basjam.ValaCompiler.appdata.xml DESTINATION ${DATADIR}/metainfo/)

# icons
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/icons/128/com.github.basjam.ValaCompiler.svg DESTINATION ${DATADIR}/icons/hicolor/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/icons/16/com.github.basjam.ValaCompiler.png DESTINATION ${DATADIR}/icons/hicolor/16x16/apps/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/icons/24/com.github.basjam.ValaCompiler.png DESTINATION ${DATADIR}/icons/hicolor/24x24/apps/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/icons/32/com.github.basjam.ValaCompiler.png DESTINATION ${DATADIR}/icons/hicolor/32x32/apps/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/icons/48/com.github.basjam.ValaCompiler.png DESTINATION ${DATADIR}/icons/hicolor/48x48/apps/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/icons/64/com.github.basjam.ValaCompiler.png DESTINATION ${DATADIR}/icons/hicolor/64x64/apps/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/icons/128/com.github.basjam.ValaCompiler.svg DESTINATION ${DATADIR}/icons/hicolor/128x128/apps/)
