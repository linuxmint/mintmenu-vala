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
        this.window.set_decorated(false);

        this.button_label = new Gtk.Label(_("Menu"));
        this.button_label.set_text("NO");
        this.button_icon = new Gtk.Image.from_icon_name ("document-open", IconSize.SMALL_TOOLBAR);

        this.button_box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
        this.button_box.pack_start(this.button_icon, false, false, 0);
        this.button_box.pack_start(this.button_label, false, false, 0);
        this.button_icon.set_padding(5, 0);

        this.window.map_event.connect(this.onWindowMap);
        this.window.unmap_event.connect(this.onWindowUnmap);
        this.window.size_allocate.connect(this.positionMenu);

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

    public void positionMenu(Gtk.Widget widget, Allocation allocation2) {
        print("POSITIONING\n");
        int ourWidth, ourHeight, entryX, entryY, entryHeight, entryWidth, newX, newY;
        int offset = 2;

        // Get our own dimensions & position
        this.window.get_size(out ourWidth, out ourHeight);
        ourHeight = ourHeight + offset;

        // Get the dimensions/position of the widgetToAlignWith
        this.applet.get_window().get_origin(out entryX, out entryY);

        Gtk.Allocation allocation;
        this.applet.get_allocation(out allocation);
        entryWidth = allocation.width;
        entryHeight = allocation.height + offset;

        // Get the monitor dimensions
        Gdk.Display display = this.applet.get_display();
        Gdk.Monitor monitor = display.get_monitor_at_window(this.applet.get_window());
        Gdk.Rectangle monitorGeometry = monitor.get_geometry();

        int applet_orient = this.applet.get_orient();
        if (applet_orient == MatePanel.AppletOrient.UP) {
            newX = entryX;
            newY = entryY - ourHeight;
        }
        else if (applet_orient == MatePanel.AppletOrient.DOWN) {
            newX = entryX;
            newY = entryY + entryHeight;
        }
        else if (applet_orient == MatePanel.AppletOrient.RIGHT) {
            newX = entryX + entryWidth;
            newY = entryY;
        }
        else {
            newX = entryX - ourWidth;
            newY = entryY;
        }

        // Adjust for offset if we reach the end of the screen
        // Bind to the right side
        if (newX + ourWidth > (monitorGeometry.x + monitorGeometry.width)) {
            newX = (monitorGeometry.x + monitorGeometry.width) - ourWidth;
            if (applet_orient == MatePanel.AppletOrient.LEFT) {
                newX -= entryWidth;
            }
        }

        // Bind to the left side
        if (newX < monitorGeometry.x) {
            newX = monitorGeometry.x;
            if (applet_orient == MatePanel.AppletOrient.RIGHT) {
                newX -= entryWidth;
            }
        }

        // Bind to the bottom
        if (newY + ourHeight > (monitorGeometry.y + monitorGeometry.height)) {
            newY = (monitorGeometry.y + monitorGeometry.height) - ourHeight;
            if (applet_orient == MatePanel.AppletOrient.UP) {
                newY -= entryHeight;
            }
        }

        // Bind to the top
        if (newY < monitorGeometry.y) {
            newY = monitorGeometry.y;
            if (applet_orient == MatePanel.AppletOrient.DOWN) {
                newY -= entryHeight;
            }
        }

        // Move window
        this.window.move(newX, newY);
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
