package org.instk.gpssensorlogger;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.location.GpsSatellite;
import android.location.GpsStatus;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.location.GpsStatus.Listener;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.os.HandlerThread;
import android.os.IBinder;
import android.os.Looper;
import android.os.Message;
import android.widget.Toast;

public class LogService extends Service implements SensorEventListener, LocationListener, Listener{
	private Looper mServiceLooper;
	private ServiceHandler mServiceHandler;

	CSensorStates mSenStates;
	CLocProvStates mLPStates; 
	boolean mGPSState;

	private SensorManager mSensorManager;
	private LocationManager mLocManager;

	private BufferedWriter[] fout=new BufferedWriter[3];
	private SimpleDateFormat day= new SimpleDateFormat("yyyyMMdd");

	// Handler that receives messages from the thread
	public final class ServiceHandler extends Handler {
		public ServiceHandler(Looper looper) {
			super(looper);
		}

		@Override
		public void handleMessage(Message msg) {

			mSensorManager=(SensorManager) getSystemService(SENSOR_SERVICE);
			mLocManager=(LocationManager) getSystemService(Context.LOCATION_SERVICE);

			//Get the names of all sources
			mSenStates = new CSensorStates(mSensorManager.getSensorList(Sensor.TYPE_ALL)); //nur noch Accelerometer
			mLPStates = new CLocProvStates(mLocManager.getAllProviders()); //ALLE Quellen
			mGPSState= false;

//			private Sensor mAccelerometer;
//			mAccelerometer = mSensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER);			
//			mSensorManager.registerListener(this, mAccelerometer, SensorManager.SENSOR_DELAY_NORMAL);
			
			try {
				open_files();
			} catch (FileNotFoundException e) {
				Toast.makeText(getApplicationContext(), "File open error: Probably you do not have required permissions.", Toast.LENGTH_SHORT).show();
				stop_recording();			
				e.printStackTrace();
			} catch (IOException e) {
				Toast.makeText(getApplicationContext(), "File open error: Probably you do not have required permissions.", Toast.LENGTH_SHORT).show();
				stop_recording();
				e.printStackTrace();
			}
			Toast.makeText(getApplicationContext(), "opening files", Toast.LENGTH_SHORT).show();
			register_listeners();
			Toast.makeText(getApplicationContext(), "registering listeners", Toast.LENGTH_SHORT).show();
		}
	}

	public LogService() {}

	@Override
	public void onCreate() {
		// Start up the thread running the service.  Note that we create a
		// separate thread because the service normally runs in the process's
		// main thread, which we don't want to block.  We also make it
		// background priority so CPU-intensive work will not disrupt our UI.
		HandlerThread thread = new HandlerThread("ServiceStartArguments");
		thread.start();

		// Get the HandlerThread's Looper and use it for our Handler 
		mServiceLooper = thread.getLooper();
		mServiceHandler = new ServiceHandler(mServiceLooper);
	}


	@Override
	public int onStartCommand(Intent intent, int flags, int startId) {
//		Toast.makeText(this, "starting service", Toast.LENGTH_SHORT).show();

		// For each start request, send a message to start a job and deliver the
		// start ID so we know which request we're stopping when we finish the job
		Message msg = mServiceHandler.obtainMessage();
		msg.arg1 = startId;
		mServiceHandler.sendMessage(msg);

		// If we get killed, after returning from here, restart
		return START_REDELIVER_INTENT;
	}


	@Override
	public IBinder onBind(Intent arg0) {
		// We don't provide binding, so return null
		return null;
	}

	@Override
	public void onDestroy() {
		// The service is no longer used and is being destroyed
		stop_recording();
//		Toast.makeText(this, "destroying service", Toast.LENGTH_SHORT).show(); 
		super.onDestroy();
	}


	private void close_files() {	//close files
		BufferedWriter[] bfout=fout;
		for (int i=0;i<3;i++) {
			if (bfout[i]!=null)
				try {
					bfout[i].close();
				} catch (IOException e) {
					Toast.makeText(this, "File close error :" + i, Toast.LENGTH_SHORT).show();
				}
		}		
		for (int i=0;i<3;i++) {
			if (bfout[i]!=null)
				try {
					bfout[i].close();
				} catch (IOException e) {
					Toast.makeText(this, "File close error :" + i, Toast.LENGTH_SHORT).show();
				}
		}
	}

	private void open_files() throws IOException, FileNotFoundException {	//open files
		//Refs
		CSensorStates lSenStates=mSenStates;
		CLocProvStates lLPStates=mLPStates;
		BufferedWriter[] bfout=fout;
		String start_text=null;

		//Open the files and register the listeners
		if (lSenStates.getNumAct()>0) {
			if (file_location("accelerometer_").exists())
				start_text = "";
			else
				start_text = "% ACCELEROMETER\n\n% Attributes:\n% system time, time stamp, sensor type, x_value, y_value, z_value \n\nacc = [";
			bfout[0]=new BufferedWriter(new FileWriter(file_location("accelerometer_"), true));

			BufferedWriter file=fout[0];
			if (file!=null) {
				try {
					file.append(start_text);
					//					file.append("SENSORS\n\nAttributes:\nsystem time, sensor name, time stamp, no of values, values \n\n");
				} catch (IOException e) {
					Toast.makeText(this, "Error: Could not write to file!", Toast.LENGTH_SHORT).show();
				}
			}
		}
		else
			bfout[0]=null;

		if (lLPStates.getNumAct()>0) {

			if (file_location("locprovider_").exists())
				start_text = "";
			else
				start_text = "% NETWORK PROVIDER\n\n% Attributes:\n% system time, provider name (3 for gps, 7 for network), pr. time, pr. accuracy, " +
						"pr. latitude, pr. longitude, pr. bearing, pr. speed \n\n" +
						"provider = [";

			bfout[1]=new BufferedWriter(new FileWriter(file_location("locprovider_"), true));
			BufferedWriter file=fout[1];

			if (file!=null) {
				try {
					file.append(start_text);
				} catch (IOException e) {
					Toast.makeText(this, "Error: Could not write to file!", Toast.LENGTH_SHORT).show();
				}
			}			
		}
		else
			bfout[1]=null;

		if (mGPSState) {

			if (file_location("gpsstate_").exists())
				start_text = "";
			else
				start_text = "% GPS STATUS\n\n% Attributes:\n% system time, PRN, Azimuth, Elevation, SNR, Almanach, " +
						"Ephemeris, Sat. used in last fix, if next: @, if no next: # \n\n" +
						"gps_status = [";

			bfout[2]=new BufferedWriter(new FileWriter(file_location("gpsstate_"), true));
			BufferedWriter file=fout[2];

			if (file!=null) {
				try {
					file.append(start_text);						
				} catch (IOException e) {
					Toast.makeText(this, "Error: Could not write to file!", Toast.LENGTH_SHORT).show();
				}
			}
		}
		else
			bfout[2]=null;
	}


	private File file_location(String ntag) {

		String state = Environment.getExternalStorageState();

		if (Environment.MEDIA_MOUNTED.equals(state)) {
			// We can read and write the media
			String ftag=day.format(new Date()); // Nur Tag als Dateiname
			File root = new File(Environment.getExternalStorageDirectory(), "GPSSensorLogger/v1.0"); //speichert in sdcard/GPSSensorLogger
			if (!root.exists()) {
				root.mkdirs();
			}

			if (ntag == null) {
				return root;
			} else
				return new File(root, ntag+ftag+".m");
		} else { // We can not read and write the media
			Toast.makeText(this, "No external Storage.", Toast.LENGTH_SHORT).show();
			return null;
		}
	}


	private void register_listeners() {
		CSensorStates lSenStates=mSenStates;
		CLocProvStates lLPStates=mLPStates;
		BufferedWriter[] bfout=fout;

		//Register the sensors
		if (bfout[0]!=null) {
			for (int i=0;i<lSenStates.getNum();i++) {
				if (lSenStates.getActive(i))
					mSensorManager.registerListener(this, mSensorManager.getDefaultSensor(lSenStates.getType(i)), 40);			
					mSensorManager.registerListener(this, mSensorManager.getDefaultSensor(lSenStates.getType(i)), lSenStates.getRate(i));			
				//						mSensorManager.registerListener(this, mSensorManager.getDefaultSensor(lSenStates.getType(i)), SensorManager.SENSOR_DELAY_FASTEST);	//change delay here		
			}
		}

		//Register listeners for active location providers
		if (bfout[1]!=null) {	
			for (int i=0;i<lLPStates.getNum();i++) {
				if (lLPStates.getActive(i))
					mLocManager.requestLocationUpdates(lLPStates.getName(i), 0, 0, this); //mintime, mindist
			}
		}

		if (bfout[2]!=null) {
			mLocManager.addGpsStatusListener(this);
		}
	}


	private void stop_recording() {
		//Stop Recording
		mSensorManager.unregisterListener(this);
		mLocManager.removeGpsStatusListener(this);
		mLocManager.removeUpdates(this);
//		Toast.makeText(this, "unregistering listeners", Toast.LENGTH_SHORT).show(); 

		close_files();		
//		Toast.makeText(this, "closing files", Toast.LENGTH_SHORT).show(); 

	}



	///////////Sensor Listener Callbacks
	public void onAccuracyChanged(Sensor sensor, int accuracy) {
		// Do nothing		
	}


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
			Toast.makeText(this, "Error: Could not write to file!4", Toast.LENGTH_SHORT).show();			
		}
	}


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

	public void onProviderEnabled(String arg0) {
		Toast.makeText(this, arg0 + " provider enabled", Toast.LENGTH_SHORT).show();
	}

	public void onStatusChanged(String arg0, int arg1, Bundle arg2) {
		//		Toast.makeText(this, arg0 + " status changed :" + arg1, Toast.LENGTH_SHORT).show();
	}

	///////GPS status callback
	public void onGpsStatusChanged(int status) {
		BufferedWriter file=fout[2];

		long tim=System.currentTimeMillis();

		//Get the status
		GpsStatus lStatus=null;
		lStatus=mLocManager.getGpsStatus(null);

		if (lStatus!=null) {
			if (file!=null) {
				try {
					file.append("\n" + String.valueOf(tim)); //System time
					Iterable<GpsSatellite> satlist=lStatus.getSatellites(); //Returns an array of GpsSatellite objects, which represent the current state of the GPS engine
					for (GpsSatellite sat:satlist) {

						file.append(", " + String.valueOf(sat.getPrn())); //Returns the PRN (pseudo-random number) for the satellite.
						file.append(", " + String.valueOf(sat.getAzimuth())); //Returns the azimuth of the satellite in degrees. The azimuth can vary between 0 and 360
						file.append(", " + String.valueOf(sat.getElevation())); //Returns the elevation of the satellite in degrees. The elevation can vary between 0 and 90.
						file.append(", " + String.valueOf(sat.getSnr())); //Returns the signal to noise ratio for the satellite
						file.append(";");
					}
				} catch (IOException e) {
					Toast.makeText(this, "Error: Could not write to file!", Toast.LENGTH_SHORT).show();
				}
			}
		}
	}

}
