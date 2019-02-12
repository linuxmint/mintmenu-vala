project('mintmenu', 'vala', 'c')

vapi_dir = join_paths(meson.current_source_dir(), 'vapi')

dependencies = [
    dependency('glib-2.0'),
    dependency('gobject-2.0'),
    dependency('gtk+-3.0'),
    dependency('gtk+-3.0'),
    dependency('libmatepanelapplet-4.0')
]

add_project_arguments(['--vapidir', vapi_dir], language: 'vala')

sources = files('mintmenu.vala')

executable('mintmenu-vala', sources, dependencies: dependencies, install : true, install_dir : '/usr/bin')

subdir('files')
