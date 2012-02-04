package org.instk.gpssensorlogger;

import java.util.List;

import android.os.Parcel;
import android.os.Parcelable;

public class CLocProvStates implements Parcelable {

	private String[] names=null;
	private boolean[] act_list=null;
	private long[] mintime=null;
	private float[] mindist=null;
	private int nman=0;
	
	public CLocProvStates(List<String> aLList) {
		nman=aLList.size();
		
		if (nman>0) {
			names=new String[nman];
			act_list=new boolean[nman];
			mintime=new long[nman];
			mindist=new float[nman];
			for (int i=0;i<nman;i++) {
				names[i]=aLList.get(i);
				mintime[i]=0;
				mindist[i]=0;
// CAREFUL: GPS AND NETWORK ARE NOW SET IN LOGSERVICE.JAVA, THIS IS ONLY FOR THE "show registered" FUNCTION!!!				
				//Set active status
				if ((names[i].equals("gps")) || (names[i].equals("network")))
//				if (names[i].equals("gps"))
					act_list[i]=true;
				else
					act_list[i]=false;				
			}
		}
	}
	
	
	
	String[] getNames() {
		return names; 
	}
	
	String getName(int i) {
		return names[i]; 
	}
	
	int getNum() {
		return nman;
	}
	
	int getNumAct() {
		int nact=0;
		for (int i=0;i<nman;i++) {
			if (act_list[i])
				nact++;
		}
		
		return nact;
	}
	
	boolean getActive(int i) {
		return act_list[i];
	}
	
//	void setActive(String prov, boolean val){
//		act_list[i]=val;
//	}	
		
	public boolean isExist(String provider) {
		for (int i=0;i<nman; i++) {
			if (names[i].equals(provider)) return true;
		}
		
		return false;
	}
	
	
	//////////////////////////////////////////////////////////////
	///Parcel Implementation
	public int describeContents() {
		return 0;
	}

	public void writeToParcel(Parcel out, int arg1) {		
		out.writeInt(nman);
		out.writeStringArray((String[]) names);
		out.writeBooleanArray(act_list);
		out.writeLongArray(mintime);
		out.writeFloatArray(mindist);
	}

	public static final Parcelable.Creator<CLocProvStates> CREATOR
	= new Parcelable.Creator<CLocProvStates>() {
		public CLocProvStates createFromParcel(Parcel source) {
			return new CLocProvStates(source);
			}

		public CLocProvStates[] newArray(int size) {
			return new CLocProvStates[size];
		}
	};
	
	private CLocProvStates(Parcel source) {
		nman=source.readInt();
		
		if (nman>0) {
			names = new String[nman];
			act_list=new boolean[nman];
			mintime=new long[nman];
			mindist=new float[nman];
			source.readStringArray((String[]) names);
			source.readBooleanArray(act_list);
			source.readLongArray(mintime);
			source.readFloatArray(mindist);
		}
	}
}
