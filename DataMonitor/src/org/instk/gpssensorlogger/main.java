package org.instk.gpssensorlogger;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import org.instk.gpssensorlogger.R;

import android.app.Activity;
import android.app.ActivityManager;
import android.app.ActivityManager.RunningServiceInfo;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.hardware.Sensor;
import android.hardware.SensorManager;
import android.location.LocationManager;
import android.os.Bundle;
import android.os.Environment;
import android.provider.Settings;
import android.view.View;
import android.view.View.OnClickListener;

import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;


public class main extends Activity implements OnClickListener {

	CSensorStates mSenStates;
	CLocProvStates mLPStates; //network (based on availability of cell tower and WiFi access points),
	//	passive (This provider can be used to passively receive location updates when other applications or services request them without actually 
	//	requesting the locations yourself. This provider will return locations generated by other providers),gps
	CLogView mLV;
	int evno=0;

	SensorManager mSenMan;
	LocationManager mLocMan;

	Button mbtn_start,mbtn_stop;

	private BufferedWriter[] fout=new BufferedWriter[2];
	private SimpleDateFormat day= new SimpleDateFormat("yyyyMMdd");
	private SimpleDateFormat dt= new SimpleDateFormat("dd.MM.yyyy HH:mm:ss");

	public static final String PREFS_NAME = "MyPrefsFile";

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		SensorManager lSenMan=(SensorManager) getSystemService(SENSOR_SERVICE);
		LocationManager lLocMan=(LocationManager) getSystemService(Context.LOCATION_SERVICE);
		mSenMan=lSenMan;
		mLocMan=lLocMan;

		if ( !lLocMan.isProviderEnabled(LocationManager.GPS_PROVIDER) ) {	//alert message if GPS is diabled
			buildAlertMessageNoGps();
		}

		//Get the names of all sources
		mSenStates = new CSensorStates(lSenMan.getSensorList(Sensor.TYPE_ALL)); //nur noch Accelerometer
		mLPStates = new CLocProvStates(lLocMan.getAllProviders()); //ALLE Quellen

		//Construct the view
		setContentView(R.layout.main);
		mLV=(CLogView) findViewById(R.id.DLtv1);
		Button lbtn_start=(Button) findViewById(R.id.DLbtn0);
		Button lbtn_stop=(Button) findViewById(R.id.DLbtn2);
		Button lbtn_erec=(Button) findViewById(R.id.DLbtn3);
		Button lbtn_show=(Button) findViewById(R.id.DLbtn4);

		TextView ltv1 = (TextView) findViewById(R.id.Atv1);
		//		ltv1.setText("This application was developed from the source codes available at github.com/yigiter/");
		ltv1.setText("Acquired sensor data (25Hz): acceleration, linear acceleration, gravity and orientation sensor\nAcquired location data: GPS and network provider"); //change comment here
		//		Linkify.addLinks(ltv1, Linkify.ALL);

		lbtn_start.setOnClickListener(this);
		lbtn_stop.setOnClickListener(this);
		lbtn_erec.setOnClickListener(this);
		lbtn_show.setOnClickListener(this);

		//retrieve preferences
		SharedPreferences mPrefs = getSharedPreferences(PREFS_NAME,MODE_PRIVATE);
		mLV.setText(mPrefs.getString("Logfile", "File Location:  " + file_location(null)));  // saved logfile or default
		lbtn_start.setEnabled(mPrefs.getBoolean("StartButton", true)); // saved start button status or default
		lbtn_stop.setEnabled(mPrefs.getBoolean("StopButton", false)); // saved stop button status or default

		if(isServiceRunning() & lbtn_start.isEnabled() == true){
			mLV.addtext("Error: start button not set properly");
			lbtn_start.setEnabled(false); lbtn_stop.setEnabled(true);
		}

		if(!isServiceRunning() & lbtn_start.isEnabled() == false){
			mLV.addtext("Error: service killed, maybe due to system reboot");
			lbtn_start.setEnabled(true); lbtn_stop.setEnabled(false);
		}
		//		if (savedInstanceState != null) {
		//			// Restore UI state from the savedInstanceState.
		//			lbtn_start.setEnabled(savedInstanceState.getBoolean("StartButton"));
		//			lbtn_stop.setEnabled(savedInstanceState.getBoolean("StopButton"));
		//			mLV.addtext(savedInstanceState.getString("Logfile"));  // retrieve former logfile
		//		}

		mbtn_start=lbtn_start;
		mbtn_stop=lbtn_stop;		
	}

	// TODO Save content of logfile in outstate bundle outstate by onSaveInstanceState(Bundle) and retrieve by onRestoreInstanceState(Bundle)
	// Funktioniert das auch bei vollem Speicher?


	@Override
	protected void onPause() {
		super.onPause();

		// We need an Editor object to make preference changes.
		// All objects are from android.context.Context
		SharedPreferences settings = getSharedPreferences(PREFS_NAME, MODE_PRIVATE);
		SharedPreferences.Editor ed = settings.edit();
		ed.putBoolean("StartButton",  mbtn_start.isEnabled()); // save start button status
		ed.putBoolean("StopButton",  mbtn_stop.isEnabled()); // save stop button status
		ed.putString("Logfile", mLV.getText().toString());  // save logfile

		ed.commit();

	}

	//	@Override
	//	public void onSaveInstanceState(Bundle savedInstanceState) {
	//		// Save UI state changes to the savedInstanceState.
	//		// This bundle will be passed to onCreate if the process is
	//		// killed and restarted.
	//		savedInstanceState.putBoolean("StartButton",  mbtn_start.isEnabled()); // save start button status
	//		savedInstanceState.putBoolean("StopButton",  mbtn_stop.isEnabled()); // save stop button status
	//		savedInstanceState.putString("Logfile", mLV.getText().toString());  // save logfile
	//		// etc.
	//		super.onSaveInstanceState(savedInstanceState);
	//	}

	public void onClick(View arg0) {
		String daytime=dt.format(new Date());

		if (arg0.getId()==R.id.DLbtn0) { //Start Recording
			//Adjust view
			mbtn_start.setEnabled(false);
			mbtn_stop.setEnabled(true);

			//Start service
			Intent intent = new Intent(this, LogService.class);
			startService(intent);

			//Log
			String ftag=dt.format(new Date());
			mLV.addtext("\nStarted Logging: " + ftag);
		}

		else if (arg0.getId()==R.id.DLbtn2) { //Stop Recording
			//Stop service
			Intent intent = new Intent(this, LogService.class);
			stopService(intent);
			
			//Log
			mLV.addtext("Stopped Logging: " + daytime);
			
			//Ask for comment and close files
			record_comment();

			//Adjust view
			mbtn_start.setEnabled(true);
			mbtn_stop.setEnabled(false);
		}
		
		else if (arg0.getId()==R.id.DLbtn3) {
			//Save console to file
			dump_console();
			mLV.addtext("Logfile saved \n");
		}
		
		else if (arg0.getId()==R.id.DLbtn4) {
			//Show registered
			show_registered();
		}
	}

	private void buildAlertMessageNoGps() {	//Alert Message in case GPS is disabled
		final AlertDialog.Builder builder = new AlertDialog.Builder(this);
		builder.setMessage("Your GPS seems to be disabled, do you want to enable it?")
		.setCancelable(false)
		.setPositiveButton("Yes", new DialogInterface.OnClickListener() {
			public void onClick(final DialogInterface dialog, final int id) {
				startActivity(new Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS));
			}
		})
		.setNegativeButton("No", new DialogInterface.OnClickListener() {
			public void onClick(final DialogInterface dialog, final int id) {
				dialog.cancel();
			}
		});
		final AlertDialog alert = builder.create();
		alert.show();
	}

	private void show_registered() { //Show registered
		CSensorStates lSenStates=mSenStates;
		CLocProvStates lLPStates=mLPStates;

		String nt="\nAVAILABLE SOURCES: \n";
		nt=nt + "SENSORS: Total Number: " + mSenStates.getNum() + " Active:" + mSenStates.getNumAct() + "\n";
		int n=0;
		for (int i=0;i<lSenStates.getNum();i++) {
			if (lSenStates.getActive(i))
				nt=nt + lSenStates.getName(i) + " (active)\n";
			else
				nt=nt + lSenStates.getName(i) + " (inactive) \n";
			n++;
		}
		nt=nt + "PROVIDERS: Total Number: " + mLPStates.getNum() + " Active:" + mLPStates.getNumAct() + "(Possibly not up to date)\n";
		for (int i=0;i<lLPStates.getNum();i++) {
			if (lLPStates.getActive(i))
				nt=nt + lLPStates.getName(i) + " (active) \n";
			else
				nt=nt + lLPStates.getName(i) + " (inactive) \n";
			n++;
		}

		if (n==0) {
			nt="No Registered Source.";
		}

		mLV.addtext(nt + "\n");
	}


	private File file_location(String ntag) {

		String state = Environment.getExternalStorageState();

		if (Environment.MEDIA_MOUNTED.equals(state)) { // We can read and write the media
			String ftag=day.format(new Date()); // date is filename
			File root = new File(Environment.getExternalStorageDirectory(), "GPSSensorLogger/v1.0"); //speichert in sdcard/GPSSensorLogger
			if (!root.exists()) {
				root.mkdirs();
			}

			if (ntag == null) {
				return root;
			} else
				return new File(root, ntag+ftag+".m");
			//  return new File(getExternalFilesDir(null), ntag + ftag + ".m");		Speichert in android/data/files/org.instk.gpssensorlogger  
		} else { // We can not read and write the media
			mLV.addtext("No external Storage.");
			return null;
		}
	}

	private void record_comment() {
		//Open Files
		try {
			BufferedWriter[] bfout=fout;
			bfout[0]=new BufferedWriter(new FileWriter(file_location("accelerometer_"), true));
			bfout[1]=new BufferedWriter(new FileWriter(file_location("locprovider_"), true));
		} catch (FileNotFoundException e) {
			Toast.makeText(getApplicationContext(), "File open error: Probably you do not have required permissions.", Toast.LENGTH_SHORT).show();
			e.printStackTrace();
		} catch (IOException e) {
			Toast.makeText(getApplicationContext(), "File open error: Probably you do not have required permissions.", Toast.LENGTH_SHORT).show();
			e.printStackTrace();
		} 

		//Dialog Window to add comments
		AlertDialog.Builder alert = new AlertDialog.Builder(this);

		alert.setTitle("Any comments?");
		alert.setMessage("Please comment on transport mode and route:");

		// Set an EditText view to get user input 
		final EditText input = new EditText(this);
		alert.setView(input);

		alert.setPositiveButton("Ok", new DialogInterface.OnClickListener() {
			public void onClick(DialogInterface dialog, int whichButton) {
				String comment = input.getText().toString();
				BufferedWriter[] bfout=fout;

				String daytime=dt.format(new Date());
				String text = "\n\n% COMMENT ( " + daytime + " ): \n% " + comment + " (acc, lin acc, grav, orn at 25Hz,gps (10s,2m), network (60s,20m))\n";  //change comment here

				//Append text and close files
				if (bfout[0]!=null)
					try {
						bfout[0].append(text); 
						bfout[0].close();
						mLV.addtext("Saved comment: "+comment);
					} catch (IOException e) {
						mLV.addtext("Error: Could not write to or close file (Sensor)");
					}
				if (bfout[1]!=null)
					try {
						bfout[1].append(text);
						bfout[1].close();
					} catch (IOException e) {
						mLV.addtext("Error: Could not write to or close file (Location)");
					}
			}
		});

		alert.setNegativeButton("Cancel", new DialogInterface.OnClickListener() {
			public void onClick(DialogInterface dialog, int whichButton) {
				BufferedWriter[] bfout=fout;
				String daytime=dt.format(new Date());
				String text = "\n\n% NO COMMENT ( " + daytime + ", acc, lin acc, grav, orn at 25Hz,gps (10s,2m), network (60s,20m))";  //change comment here

				//Append text and close files
				if (bfout[0]!=null)
					try {
						bfout[0].append(text); 
						bfout[0].close();
					} catch (IOException e) {
						mLV.addtext("Error: Could not write to or close file (Sensor)");
					}
				if (bfout[1]!=null)
					try {
						bfout[1].append(text);
						bfout[1].close();
					} catch (IOException e) {
						mLV.addtext("Error: Could not write to or close file (Location)");
					}
				// Canceled.
			}
		});
		alert.show();
	}


	private void dump_console() {
		try {
			String daytime=dt.format(new Date());
			BufferedWriter file = new BufferedWriter(new FileWriter(file_location("log_"), true));
			file.append("LOGFILE ( " + daytime + ")\n\n\n" + mLV.getText().toString() + "\n\n");
			file.close();
		}
		catch (FileNotFoundException e) {
			mLV.addtext("Error: Could not open file for writing");
		}
		catch (IOException e1) {
			mLV.addtext("Error: Could not save file!");
		}
	}

	private boolean isServiceRunning() {
		ActivityManager manager = (ActivityManager) getSystemService(ACTIVITY_SERVICE);
		for (RunningServiceInfo service : manager.getRunningServices(Integer.MAX_VALUE)) {
			if ("org.instk.gpssensorlogger.LogService".equals(service.service.getClassName())) {
				return true;
			}
		}
		return false;
	}
}