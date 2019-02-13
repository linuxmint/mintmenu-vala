using Gtk;
using GLib;


public class MintMenu {

    /* Fields */
    public MatePanel.Applet applet;
    public Gtk.Box button_box;
    public Gtk.Label button_label;
    public Gtk.Image button_icon;
    public Gtk.Window window;

    /* Constructor */
    public MintMenu(MatePanel.Applet applet) {
        this.applet = applet;
        this.window = new Gtk.Window();

        this.button_label = new Gtk.Label(_("Menu"));
        this.button_label.set_text("NO");
        this.button_icon = new Gtk.Image.from_icon_name ("document-open", IconSize.SMALL_TOOLBAR);

        this.button_box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
        this.button_box.pack_start(this.button_icon, false, false, 0);
        this.button_box.pack_start(this.button_label, false, false, 0);
        this.button_icon.set_padding(5, 0);

        this.window.map_event.connect(this.onWindowMap);
        this.window.unmap_event.connect(this.onWindowUnmap);
        // this.window.size_allocate.connect(this.positionMenu);

        this.applet.add(this.button_box);
        this.applet.show_all();
        this.applet.button_press_event.connect(this.showMenu);
    }


    public bool showMenu(Gtk.Widget widget, Gdk.EventButton event)
    {
        if (this.window.is_visible()) {
            this.window.hide();
        }
        else {
            this.window.show();
        }
        return true;
    }

    public bool onWindowMap(Gtk.Widget widget, Gdk.EventAny event) {
        print("MAPPING\n");
        this.applet.get_style_context().set_state(Gtk.StateFlags.SELECTED);
        this.button_box.get_style_context().set_state(Gtk.StateFlags.SELECTED);
        return false;
    }

    public bool onWindowUnmap(Gtk.Widget widget, Gdk.EventAny event) {
        print("UNMAPPING\n");
        this.applet.get_style_context().set_state(Gtk.StateFlags.NORMAL);
        this.button_box.get_style_context().set_state(Gtk.StateFlags.NORMAL);
        return false;
    }
}



private bool factory_callback(MatePanel.Applet applet, string iid)
{
    if (iid != "MintMenuValaApplet") {
        return false;
    }
    print("Loading applet\n");

    MintMenu menu = new MintMenu(applet);

    Gtk.main();
    return true;
}

void main(string[] args) {
    Gtk.init(ref args);

    // Set i18n
    Intl.setlocale(LocaleCategory.ALL, "");
    Intl.textdomain("mintmenu");
    Intl.bindtextdomain("mintmenu", "/usr/share/linuxmint/locale");
    Intl.bind_textdomain_codeset("mintmenu", "UTF-8");

    MatePanel.Applet.factory_main("MintMenuValaAppletFactory", true, typeof (MatePanel.Applet), factory_callback);
}
