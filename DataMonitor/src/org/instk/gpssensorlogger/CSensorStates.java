package org.instk.gpssensorlogger;

import java.util.List;

import android.hardware.Sensor;
import android.hardware.SensorManager;
import android.os.Parcel;
import android.os.Parcelable;

public class CSensorStates  implements Parcelable{
	
	private String[] names=null;
	private int[] types=null;
	private boolean[] act_list=null;
	private int nsen=0;
	private int[] rates=null;
	
	
	public CSensorStates (List<Sensor> aSList) {
		nsen=aSList.size();

		if (nsen>0) {
			names = new String[nsen];
			types = new int[nsen];
			act_list=new boolean[nsen];
			rates=new int[nsen];

			//Set name
			for (int i=0;i<nsen;i++) {

				//Set type and active status
				types[i]=aSList.get(i).getType();
				act_list[i]=true;
				rates[i]=SensorManager.SENSOR_DELAY_FASTEST; // UNUSED!!

				switch (types[i]) {
				case (Sensor.TYPE_ACCELEROMETER):
					names[i]="accelerometer";
//					act_list[i]=false;
				break;
				case (Sensor.TYPE_GYROSCOPE):
					names[i]="gyroscope";
					act_list[i]=false;
				break;
				case (Sensor.TYPE_PROXIMITY):
					names[i]="proximity";
					act_list[i]=false;
				break;
				case (Sensor.TYPE_MAGNETIC_FIELD):
					names[i]="magnetic field";
					act_list[i]=false;
				break;
				case (Sensor.TYPE_ROTATION_VECTOR):
					names[i]="rotation vector";
					act_list[i]=false;
				break;
				case (Sensor.TYPE_LIGHT):
					names[i]="light";
					act_list[i]=false;
				break;
				case (Sensor.TYPE_PRESSURE):
					names[i]="pressure";
					act_list[i]=false;
				break;
				case (Sensor.TYPE_TEMPERATURE):
					names[i]="temperature";
					act_list[i]=false;
				break;
				case (Sensor.TYPE_GRAVITY):
					names[i]="gravity";
//				act_list[i]=false;
				break;
				case (Sensor.TYPE_LINEAR_ACCELERATION):
					names[i]="lin. acceleration";
//				act_list[i]=false;
				break;
				case (Sensor.TYPE_ORIENTATION):
					names[i]="orientation";
//				act_list[i]=false;
				break;
				default:
					names[i]=aSList.get(i).getName();
					act_list[i]=false;
				}
			}
		}
	}
		
	String getName(int i) {
		return names[i];
	}
		
	Boolean getActive(int i) {
		return act_list[i];
	}
	
	int getNum(){
		return nsen;
	}
	
	int getNumAct() {
		int nact=0;
		for (int i=0;i<nsen;i++) {
			if (act_list[i])
				nact++;
		}
		return nact;
	}
	
	public int getType(int i) {
		return types[i];
	}
	
	public int getRate(int i) {
		return rates[i];
	}

	//////////////////////////////////////////////////////////////////
	//Required for Parcelable classes
	public int describeContents() {
		return 0;
	}

	public void writeToParcel(Parcel out, int flag) {
		out.writeInt(nsen);
		out.writeStringArray((String[]) names);
		out.writeIntArray(types);
		out.writeBooleanArray(act_list);
		out.writeIntArray(rates);
	}
	
	public static final Parcelable.Creator<CSensorStates> CREATOR
	= new Parcelable.Creator<CSensorStates>() {
		public CSensorStates createFromParcel(Parcel source) {
			return new CSensorStates(source);
			}

		public CSensorStates[] newArray(int size) {
			return new CSensorStates[size];
		}
	};
	
	private CSensorStates(Parcel source) {
		nsen=source.readInt();
		
		if (nsen>0) {
			names = new String[nsen];
			types = new int[nsen];
			rates = new int[nsen];
			act_list=new boolean[nsen];
			source.readStringArray((String[]) names);
			source.readIntArray(types);
			source.readBooleanArray(act_list);
			source.readIntArray(rates);
		}
	}
};


