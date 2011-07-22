/*
 * Compile using:
 * valac --pkg gtk+-3.0 --pkg gdk-x11-3.0 --pkg gstreamer-0.10 --pkg gstreamer-interfaces-0.10 videoview.vala
 *
 */
using Gtk;
using Gst;

public class VideoView : Gtk.Window
{
  private Gtk.DrawingArea drawing_area;
  private X.ID xid;
  private Gst.Element camerabin;
  private string AppName = "Polaroid";
  private int counter = 1;
  private bool recording;	  

  public VideoView ()
  {
	  this.destroy.connect (Gtk.main_quit);

	  var vbox = new Gtk.VBox (false, 0);
	  this.drawing_area = new Gtk.DrawingArea ();
	  this.drawing_area.set_size_request (640, 480);
	  this.drawing_area.realize.connect (on_realize);
	  vbox.pack_start (this.drawing_area, true, true, 0);

	  var record_button = new Button.from_stock (Gtk.Stock.MEDIA_RECORD);
	  record_button.clicked.connect (on_record);
	  var photo_button = new Button.with_label ("Take a picture");
	  photo_button.clicked.connect (on_take_picture);
	  var stop_button = new Button.from_stock (Gtk.Stock.MEDIA_STOP);
/*	  stop_button.clicked.connect (on_stop);*/
	  var button_box = new Gtk.HButtonBox ();
	  button_box.add (record_button);
	  button_box.add (photo_button);
	  button_box.add (stop_button);
	  vbox.pack_start (button_box, false, true, 5);

	  this.add (vbox);

	  this.camerabin = Gst.ElementFactory.make ("camerabin", "camera");
	  var bus = this.camerabin.get_bus ();
	  bus.set_sync_handler (on_bus_callback);
  }

  private Gst.BusSyncReply on_bus_callback (Gst.Bus bus, Gst.Message message)
  {
	  if (message.get_structure () != null && message.get_structure().has_name("prepare-xwindow-id")) {
	  var xoverlay = message.src as Gst.XOverlay;
	  xoverlay.set_xwindow_id (this.xid);
	  return Gst.BusSyncReply.DROP;
	  }

	  return Gst.BusSyncReply.PASS;
  }

  private void on_realize ()
  {
    this.xid = gdk.window_get_xid (this.drawing_area.window);
    on_record ();
  }

  private void on_record ()
  {
	if(this.recording = true) {
		this.camerabin.set_state (Gst.State.PAUSED);
		this.set_title ((this.AppName) + " - Paused");
		this.recording = false;
		}			
			
	else if (this.recording = false) {
		this.camerabin.set_state (Gst.State.PLAYING);
		this.set_title ((this.AppName) + " - Recording");
		this.recording = true;
		}
  }

  private void on_take_picture ()
  {
	  if (this.recording)
	  {
	    var filename = (this.AppName) + " Snapshot " + "%d".printf (this.counter) + ".jpg";
	    this.set_title ("%d".printf (this.counter) + " photos taken");
	    this.counter++;
	    this.camerabin.set ("filename", filename);
	    GLib.Signal.emit_by_name (this.camerabin, "capture-start");
	  }
  }

  public static int main (string[] args)
  {
	  Gst.init (ref args);
	  Gtk.init (ref args);

	  var videoview = new VideoView ();
	  videoview.show_all ();

	  Gtk.main ();

	  return 0;
  }
}
