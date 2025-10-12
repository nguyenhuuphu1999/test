/*
 * This file is auto-generated.  DO NOT MODIFY.
 */
package com.example.vpncn2_app;
/**
 * This class represents a structured error from the Android VPN service.
 * The code field is a string that can be used to determine the error category in Java.
 * The errorJson contains a JSON string of the error details that can be passed back to TypeScript.
 */
public class DetailedJsonError implements android.os.Parcelable
{
  public java.lang.String code;
  public java.lang.String errorJson;
  public static final android.os.Parcelable.Creator<DetailedJsonError> CREATOR = new android.os.Parcelable.Creator<DetailedJsonError>() {
    @Override
    public DetailedJsonError createFromParcel(android.os.Parcel _aidl_source) {
      DetailedJsonError _aidl_out = new DetailedJsonError();
      _aidl_out.readFromParcel(_aidl_source);
      return _aidl_out;
    }
    @Override
    public DetailedJsonError[] newArray(int _aidl_size) {
      return new DetailedJsonError[_aidl_size];
    }
  };
  @Override public final void writeToParcel(android.os.Parcel _aidl_parcel, int _aidl_flag)
  {
    int _aidl_start_pos = _aidl_parcel.dataPosition();
    _aidl_parcel.writeInt(0);
    _aidl_parcel.writeString(code);
    _aidl_parcel.writeString(errorJson);
    int _aidl_end_pos = _aidl_parcel.dataPosition();
    _aidl_parcel.setDataPosition(_aidl_start_pos);
    _aidl_parcel.writeInt(_aidl_end_pos - _aidl_start_pos);
    _aidl_parcel.setDataPosition(_aidl_end_pos);
  }
  public final void readFromParcel(android.os.Parcel _aidl_parcel)
  {
    int _aidl_start_pos = _aidl_parcel.dataPosition();
    int _aidl_parcelable_size = _aidl_parcel.readInt();
    try {
      if (_aidl_parcelable_size < 4) throw new android.os.BadParcelableException("Parcelable too small");;
      if (_aidl_parcel.dataPosition() - _aidl_start_pos >= _aidl_parcelable_size) return;
      code = _aidl_parcel.readString();
      if (_aidl_parcel.dataPosition() - _aidl_start_pos >= _aidl_parcelable_size) return;
      errorJson = _aidl_parcel.readString();
    } finally {
      if (_aidl_start_pos > (Integer.MAX_VALUE - _aidl_parcelable_size)) {
        throw new android.os.BadParcelableException("Overflow in the size of parcelable");
      }
      _aidl_parcel.setDataPosition(_aidl_start_pos + _aidl_parcelable_size);
    }
  }
  @Override
  public int describeContents() {
    int _mask = 0;
    return _mask;
  }
}
