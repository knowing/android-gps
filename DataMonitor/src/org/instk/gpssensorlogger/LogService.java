package org.instk.gpssensorlogger;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter;
//import java.io.FileNotFoundException;
//import java.io.FileWriter;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.os.HandlerThread;
import android.os.IBinder;
import android.os.Looper;
import android.os.Message;
import android.widget.Toast;

public class LogService extends Service implements SensorEventListener, LocationListener{
	private Looper mServiceLooper;
	private ServiceHandler mServiceHandler;
	private HandlerThread mHandlerThread;;

	CSensorStates mSenStates;

	private SensorManager mSensorManager;
	private LocationManager mLocManager;
	private NotificationManager mNotificationManager;

	private BufferedWriter[] fout=new BufferedWriter[2];
	private SimpleDateFormat day= new SimpleDateFormat("yyyyMMdd");

	// Handler that receives messages from the thread
	public final class ServiceHandler extends Handler {
		public ServiceHandler(Looper looper) {
			super(looper);
		}

		@Override
		public void handleMessage(Message msg) {
			// Acquire a reference to the system Sensor and Location Manager
			mSensorManager=(SensorManager) getSystemService(Context.SENSOR_SERVICE);
			mLocManager=(LocationManager) getSystemService(Context.LOCATION_SERVICE);

			//Get the names of all sensor sources
			mSenStates = new CSensorStates(mSensorManager.getSensorList(Sensor.TYPE_ALL)); //nur noch Accelerometer

			//			Sensor mAccelerometer;
			//			mAccelerometer = mSensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER);			
			//			mSensorManager.registerListener(this, mAccelerometer, 40);

			// open files
			try {
				open_files();
			} catch (FileNotFoundException e) {
				Toast.makeText(getApplicationContext(), "File open error: Probably you do not have required permissions.", Toast.LENGTH_LONG).show();
				stopSelf();			
				e.printStackTrace();
			} catch (IOException e) {
				Toast.makeText(getApplicationContext(), "File open error: Probably you do not have required permissions.", Toast.LENGTH_LONG).show();
				stopSelf();
				e.printStackTrace();
			}

			// register event listeners
			register_listeners();

			// Set Status Bar Notification
			mNotificationManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
			Notification notification = new Notification(R.drawable.ic_launcher, "Logging service started",
					System.currentTimeMillis());
			Intent notificationIntent = new Intent(getApplicationContext(), main.class);
			PendingIntent pendingIntent = PendingIntent.getActivity(getApplicationContext(), 0, notificationIntent, 0);
			notification.setLatestEventInfo(getApplicationContext(), "GPS and Sensor Logger",
					"Logging service running", pendingIntent);
			notification.flags = Notification.FLAG_ONGOING_EVENT;
			mNotificationManager.notify(1, notification);
		}
	}

	public LogService() {}

	@Override
	public void onCreate() {
		// Start up the thread running the service.  Note that we create a separate thread because the service normally runs in the process's
		// main thread, which we don't want to block.  We also make it background priority so CPU-intensive work will not disrupt our UI.
		HandlerThread thread = new HandlerThread("DataLogging");
		thread.start();

		// Get the HandlerThread's Looper and use it for our Handler 
		mServiceLooper = thread.getLooper();
		mServiceHandler = new ServiceHandler(mServiceLooper);
		super.onCreate(); //anders
	}


	@Override
	public int onStartCommand(Intent intent, int flags, int startId) {

		// For each start request, send a message to start a job and deliver the start ID so we know which request we're stopping when we finish the job
		Message msg = mServiceHandler.obtainMessage();
		msg.arg1 = startId;
		mServiceHandler.sendMessage(msg);

		// If we get killed, after returning from here, restart
		return START_STICKY;
	}

	@Override
	public IBinder onBind(Intent arg0) {		// We don't provide binding, so return null
		return null;
	}

	@Override
	public void onDestroy() {	// The service is no longer used and is being destroyed
		stop_recording();
		mNotificationManager.cancelAll();
		super.onDestroy(); 
	}

	private void open_files() throws IOException, FileNotFoundException {	//open files
		//References
		BufferedWriter[] bfout=fout;
		String start_text=null;

		// Sensors
		if (file_location("accelerometer_").exists())
			start_text = "";
		else
			start_text = "% ACCELEROMETER\n\n% Attributes:\n% system time, time stamp, sensor type, x_value, y_value, z_value \n\nacc = [";

		bfout[0]=new BufferedWriter(new FileWriter(file_location("accelerometer_"), true));

		if (bfout[0]!=null) {
			try {
				bfout[0].append(start_text);
			} catch (IOException e) {
				Toast.makeText(this, "Error: Could not write to file!", Toast.LENGTH_SHORT).show();
			}
		}

		// Location Provider
		if (file_location("locprovider_").exists())
			start_text = "";
		else
			start_text = "% NETWORK PROVIDER\n\n% Attributes:\n% system time, provider name (3 for gps, 7 for network), 0, pr. accuracy, " +
					"pr. latitude, pr. longitude, pr. bearing, pr. speed \n\n" + "provider = [";

		bfout[1]=new BufferedWriter(new FileWriter(file_location("locprovider_"), true));

		if (bfout[1]!=null) {
			try {
				bfout[1].append(start_text);
			} catch (IOException e) {
				Toast.makeText(this, "Error: Could not write to file!", Toast.LENGTH_SHORT).show();
			}
		} 
	}


	private File file_location(String ntag) {

		String state = Environment.getExternalStorageState();

		if (Environment.MEDIA_MOUNTED.equals(state)) {
			// We can read and write the media
			String ftag=day.format(new Date()); // date is filename
			File root = new File(Environment.getExternalStorageDirectory(), "GPSSensorLogger/v1.0"); // saved in sdcard/GPSSensorLogger
			if (!root.exists()) {
				root.mkdirs();
			}

			if (ntag == null) {
				return root;
			} else
				return new File(root, ntag+ftag+".m");
			//  return new File(getExternalFilesDir(null), ntag + ftag + ".m");		Speichert in android/data/files/org.instk.gpssensorlogger  
		} else { // We can not read and write the media
			Toast.makeText(this, "No external Storage.", Toast.LENGTH_SHORT).show();
			return null;
		}
	}


	private void register_listeners() {
		CSensorStates lSenStates=mSenStates;
		BufferedWriter[] bfout=fout;
		
		mHandlerThread = new HandlerThread("SensorLogThread");
		mHandlerThread.start();
		Handler handler = new Handler(mHandlerThread.getLooper());

		//Register the sensors
		if (bfout[0]!=null) {
			for (int i=0;i<lSenStates.getNum();i++) {
				if (lSenStates.getActive(i))
					mSensorManager.registerListener(this, mSensorManager.getDefaultSensor(lSenStates.getType(i)), 40, handler);			// 40ms -> 25 Hz
			}
		}

		//Register listeners for active location providers
		if (bfout[1]!=null) {	
			mLocManager.requestLocationUpdates(LocationManager.NETWORK_PROVIDER, 60000, 20, this); //mintime 60s, mindist 20m
			mLocManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, 10000, 2, this); //mintime 10s, mindist 2m
		}
	}

	private void stop_recording() {
		//Stop Recording
//		mSensorManager.unregisterListener(this, mSensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER));
//		mSensorManager.unregisterListener(this, mSensorManager.getDefaultSensor(Sensor.TYPE_GRAVITY));
//		mSensorManager.unregisterListener(this, mSensorManager.getDefaultSensor(Sensor.TYPE_LINEAR_ACCELERATION));
//		mSensorManager.unregisterListener(this, mSensorManager.getDefaultSensor(Sensor.TYPE_ORIENTATION));
		mSensorManager.unregisterListener(this);
		mLocManager.removeUpdates(this);
		close_files();
		
		mHandlerThread.interrupt(); // <-- OK
	    try {
	    	mHandlerThread.join(1000);
		} catch (InterruptedException e) {
			Toast.makeText(this, "Thread can't be stopped" , Toast.LENGTH_SHORT).show();
			e.printStackTrace();
		} // optionally wait for the thread to exit
	}

	private void close_files() {	//close files
		BufferedWriter[] bfout=fout;
		if (bfout[0]!=null)
			try {
				bfout[0].close();
			} catch (IOException e) {
				Toast.makeText(this, "File close error: Sensors" , Toast.LENGTH_SHORT).show();
			}

		if (bfout[1]!=null)
			try {
				bfout[1].close();
			} catch (IOException e) {
				Toast.makeText(this, "File close error: Location", Toast.LENGTH_SHORT).show();
			}
	}

	///////////Sensor Listener Callbacks
	public void onSensorChanged(SensorEvent ev) {
		BufferedWriter file=fout[0];

		if (file==null) //Something is wrong
			return;

		long tim=System.currentTimeMillis();
		try {
			file.append("\n" + String.valueOf(tim));
			//					file.append(", " + String.valueOf(ev.timestamp));
			file.append(", 0, " + String.valueOf(ev.sensor.getType())); // col.2 = 0, col.3: sensor type
			for (int i=0;i<3;i++) //originally "len"
				file.append(", " + (String.valueOf(ev.values[i])));
			file.append(";");
		} catch (IOException e) {
			// TODO Hier erscheint nach Beenden des Services folgende Fehlermeldung: Anscheinend ist die Datei geschlossen, bevor der Listener beendet ist
			Toast.makeText(this, "Error: Could not write to file!", Toast.LENGTH_SHORT).show();			
		}
	}

	public void onAccuracyChanged(Sensor sensor, int accuracy) {}


	/////////Location provider callbacks
	public void onLocationChanged(Location loc) {
		BufferedWriter file=fout[1];

		if (file==null)
			//Something is wrong
			return;
		long tim=System.currentTimeMillis();
		try {
			file.append("\n" + String.valueOf(tim)); //Returns the current system time in milliseconds since January 1, 1970 00:00:00 UTC. This method shouldn't be used for measuring timeouts or other elapsed time measurements, as changing the system time can affect the results.
			file.append(", " + String.valueOf(loc.getProvider().length())); //Returns the name of the provider that generated this fix, or null if it is not associated with a provider
			//				file.append(", " + String.valueOf(loc.getTime())); //Returns the UTC time of this fix, in milliseconds since January 1, 1970.
			file.append(", 0, " + String.valueOf(loc.getAccuracy())); //0 for col. 3 + col.4: Returns the accuracy of the fix in meters. If hasAccuracy() is false, 0.0 is returned
			file.append(", " + String.valueOf(loc.getLatitude()));
			file.append(", " + String.valueOf(loc.getLongitude()));
			file.append(", " + String.valueOf(loc.getBearing())); //Returns the direction of travel in degrees East of true North. If hasBearing() is false, 0.0 is returned
			file.append(", " + String.valueOf(loc.getSpeed())); //Returns the speed of the device over ground in meters/second. If hasSpeed() is false, 0.0 is returned
			file.append(";");
		} catch (IOException e) {
			Toast.makeText(this, "Error: Could not write to file!", Toast.LENGTH_SHORT).show();
		}
	}

	public void onProviderDisabled(String arg0) {
		Toast.makeText(this, arg0 + " provider disabled", Toast.LENGTH_SHORT).show();
	}

	public void onProviderEnabled(String arg0) {}

	public void onStatusChanged(String arg0, int arg1, Bundle arg2) {}

}
