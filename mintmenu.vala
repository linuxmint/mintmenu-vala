using Gtk;
using GLib;

private bool factory_callback(MatePanel.Applet applet, string iid)
{
    print("Loading applet");
    if (iid != "MintMenuValaApplet") {
        return false;
    }

    Gtk.Box box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
    Gtk.Label label = new Gtk.Label("LABEL");
    box.pack_start(label, false, false, 0);

    applet.add(box);
    applet.show();
    return true;
}

void main(string[] args) {
    print("WE ARE HERE!");
    Gtk.init(ref args);
    MatePanel.Applet.factory_main("MintMenuValaAppletFactory", true, typeof (MatePanel.Applet), factory_callback);
}
