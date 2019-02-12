using Gtk;
using GLib;

private bool factory_callback(MatePanel.Applet applet, string iid)
{
    if (iid != "MintMenuValaApplet") {
        return false;
    }
    print("Loading applet\n");

    Gtk.Box box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
    Gtk.Label label = new Gtk.Label("LABEL");
    box.pack_start(label, false, false, 0);

    applet.add(box);
    applet.show_all();
    return true;
}

void main(string[] args) {
    Gtk.init(ref args);
    MatePanel.Applet.factory_main("MintMenuValaAppletFactory", true, typeof (MatePanel.Applet), factory_callback);
}
