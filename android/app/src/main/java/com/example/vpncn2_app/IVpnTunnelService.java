/*
 * This file is auto-generated.  DO NOT MODIFY.
 */
package com.example.vpncn2_app;
/** AIDL for com.example.vpncn2_app.vpn.VpnTunnelService. */
public interface IVpnTunnelService extends android.os.IInterface
{
  /** Default implementation for IVpnTunnelService. */
  public static class Default implements com.example.vpncn2_app.IVpnTunnelService
  {
    /**
     * Establishes a system-wide VPN connected to a remote Outline proxy server.
     * All device traffic is routed as follows:
     *  |VPN TUN interface| <-> |outline-go-tun2socks| <-> |Outline server|.
     * 
     * This method can be called multiple times with different configurations. The VPN will not be
     * torn down. Broadcasts an intent with action OutlinePlugin.Action.START and an error code
     * extra with the result of the operation, as defined in OutlinePlugin.ErrorCode. Displays a
     * persistent notification for the duration of the tunnel.
     * 
     * @param config tunnel configuration parameters.
     * @param isAutoStart boolean whether the tunnel was started without user intervention.
     * @return error code as defined in OutlinePlugin.ErrorCode.
     */
    @Override public com.example.vpncn2_app.DetailedJsonError startTunnel(com.example.vpncn2_app.TunnelConfig config) throws android.os.RemoteException
    {
      return null;
    }
    /**
     * Tears down a tunnel started by calling `startTunnel`. Stops tun2socks, Outline, and
     * the system-wide VPN.
     * 
     * @param tunnelId unique identifier for the tunnel.
     * @return error code representing whether the operation was successful.
     */
    @Override public com.example.vpncn2_app.DetailedJsonError stopTunnel(java.lang.String tunnelId) throws android.os.RemoteException
    {
      return null;
    }
    /**
     * Determines whether a tunnel has been started.
     * 
     * @param tunnelId unique identifier for the tunnel.
     * @return boolean indicating whether the tunnel is active.
     */
    @Override public boolean isTunnelActive(java.lang.String tunnelId) throws android.os.RemoteException
    {
      return false;
    }
    /**
     * Initializes the error reporting framework on the VPN service process.
     * 
     * @param apiKey Sentry API key.
     */
    @Override public void initErrorReporting(java.lang.String apiKey) throws android.os.RemoteException
    {
    }
    @Override
    public android.os.IBinder asBinder() {
      return null;
    }
  }
  /** Local-side IPC implementation stub class. */
  public static abstract class Stub extends android.os.Binder implements com.example.vpncn2_app.IVpnTunnelService
  {
    /** Construct the stub at attach it to the interface. */
    public Stub()
    {
      this.attachInterface(this, DESCRIPTOR);
    }
    /**
     * Cast an IBinder object into an com.example.vpncn2_app.IVpnTunnelService interface,
     * generating a proxy if needed.
     */
    public static com.example.vpncn2_app.IVpnTunnelService asInterface(android.os.IBinder obj)
    {
      if ((obj==null)) {
        return null;
      }
      android.os.IInterface iin = obj.queryLocalInterface(DESCRIPTOR);
      if (((iin!=null)&&(iin instanceof com.example.vpncn2_app.IVpnTunnelService))) {
        return ((com.example.vpncn2_app.IVpnTunnelService)iin);
      }
      return new com.example.vpncn2_app.IVpnTunnelService.Stub.Proxy(obj);
    }
    @Override public android.os.IBinder asBinder()
    {
      return this;
    }
    @Override public boolean onTransact(int code, android.os.Parcel data, android.os.Parcel reply, int flags) throws android.os.RemoteException
    {
      java.lang.String descriptor = DESCRIPTOR;
      if (code >= android.os.IBinder.FIRST_CALL_TRANSACTION && code <= android.os.IBinder.LAST_CALL_TRANSACTION) {
        data.enforceInterface(descriptor);
      }
      switch (code)
      {
        case INTERFACE_TRANSACTION:
        {
          reply.writeString(descriptor);
          return true;
        }
      }
      switch (code)
      {
        case TRANSACTION_startTunnel:
        {
          com.example.vpncn2_app.TunnelConfig _arg0;
          _arg0 = _Parcel.readTypedObject(data, com.example.vpncn2_app.TunnelConfig.CREATOR);
          com.example.vpncn2_app.DetailedJsonError _result = this.startTunnel(_arg0);
          reply.writeNoException();
          _Parcel.writeTypedObject(reply, _result, android.os.Parcelable.PARCELABLE_WRITE_RETURN_VALUE);
          break;
        }
        case TRANSACTION_stopTunnel:
        {
          java.lang.String _arg0;
          _arg0 = data.readString();
          com.example.vpncn2_app.DetailedJsonError _result = this.stopTunnel(_arg0);
          reply.writeNoException();
          _Parcel.writeTypedObject(reply, _result, android.os.Parcelable.PARCELABLE_WRITE_RETURN_VALUE);
          break;
        }
        case TRANSACTION_isTunnelActive:
        {
          java.lang.String _arg0;
          _arg0 = data.readString();
          boolean _result = this.isTunnelActive(_arg0);
          reply.writeNoException();
          reply.writeInt(((_result)?(1):(0)));
          break;
        }
        case TRANSACTION_initErrorReporting:
        {
          java.lang.String _arg0;
          _arg0 = data.readString();
          this.initErrorReporting(_arg0);
          reply.writeNoException();
          break;
        }
        default:
        {
          return super.onTransact(code, data, reply, flags);
        }
      }
      return true;
    }
    private static class Proxy implements com.example.vpncn2_app.IVpnTunnelService
    {
      private android.os.IBinder mRemote;
      Proxy(android.os.IBinder remote)
      {
        mRemote = remote;
      }
      @Override public android.os.IBinder asBinder()
      {
        return mRemote;
      }
      public java.lang.String getInterfaceDescriptor()
      {
        return DESCRIPTOR;
      }
      /**
       * Establishes a system-wide VPN connected to a remote Outline proxy server.
       * All device traffic is routed as follows:
       *  |VPN TUN interface| <-> |outline-go-tun2socks| <-> |Outline server|.
       * 
       * This method can be called multiple times with different configurations. The VPN will not be
       * torn down. Broadcasts an intent with action OutlinePlugin.Action.START and an error code
       * extra with the result of the operation, as defined in OutlinePlugin.ErrorCode. Displays a
       * persistent notification for the duration of the tunnel.
       * 
       * @param config tunnel configuration parameters.
       * @param isAutoStart boolean whether the tunnel was started without user intervention.
       * @return error code as defined in OutlinePlugin.ErrorCode.
       */
      @Override public com.example.vpncn2_app.DetailedJsonError startTunnel(com.example.vpncn2_app.TunnelConfig config) throws android.os.RemoteException
      {
        android.os.Parcel _data = android.os.Parcel.obtain();
        android.os.Parcel _reply = android.os.Parcel.obtain();
        com.example.vpncn2_app.DetailedJsonError _result;
        try {
          _data.writeInterfaceToken(DESCRIPTOR);
          _Parcel.writeTypedObject(_data, config, 0);
          boolean _status = mRemote.transact(Stub.TRANSACTION_startTunnel, _data, _reply, 0);
          _reply.readException();
          _result = _Parcel.readTypedObject(_reply, com.example.vpncn2_app.DetailedJsonError.CREATOR);
        }
        finally {
          _reply.recycle();
          _data.recycle();
        }
        return _result;
      }
      /**
       * Tears down a tunnel started by calling `startTunnel`. Stops tun2socks, Outline, and
       * the system-wide VPN.
       * 
       * @param tunnelId unique identifier for the tunnel.
       * @return error code representing whether the operation was successful.
       */
      @Override public com.example.vpncn2_app.DetailedJsonError stopTunnel(java.lang.String tunnelId) throws android.os.RemoteException
      {
        android.os.Parcel _data = android.os.Parcel.obtain();
        android.os.Parcel _reply = android.os.Parcel.obtain();
        com.example.vpncn2_app.DetailedJsonError _result;
        try {
          _data.writeInterfaceToken(DESCRIPTOR);
          _data.writeString(tunnelId);
          boolean _status = mRemote.transact(Stub.TRANSACTION_stopTunnel, _data, _reply, 0);
          _reply.readException();
          _result = _Parcel.readTypedObject(_reply, com.example.vpncn2_app.DetailedJsonError.CREATOR);
        }
        finally {
          _reply.recycle();
          _data.recycle();
        }
        return _result;
      }
      /**
       * Determines whether a tunnel has been started.
       * 
       * @param tunnelId unique identifier for the tunnel.
       * @return boolean indicating whether the tunnel is active.
       */
      @Override public boolean isTunnelActive(java.lang.String tunnelId) throws android.os.RemoteException
      {
        android.os.Parcel _data = android.os.Parcel.obtain();
        android.os.Parcel _reply = android.os.Parcel.obtain();
        boolean _result;
        try {
          _data.writeInterfaceToken(DESCRIPTOR);
          _data.writeString(tunnelId);
          boolean _status = mRemote.transact(Stub.TRANSACTION_isTunnelActive, _data, _reply, 0);
          _reply.readException();
          _result = (0!=_reply.readInt());
        }
        finally {
          _reply.recycle();
          _data.recycle();
        }
        return _result;
      }
      /**
       * Initializes the error reporting framework on the VPN service process.
       * 
       * @param apiKey Sentry API key.
       */
      @Override public void initErrorReporting(java.lang.String apiKey) throws android.os.RemoteException
      {
        android.os.Parcel _data = android.os.Parcel.obtain();
        android.os.Parcel _reply = android.os.Parcel.obtain();
        try {
          _data.writeInterfaceToken(DESCRIPTOR);
          _data.writeString(apiKey);
          boolean _status = mRemote.transact(Stub.TRANSACTION_initErrorReporting, _data, _reply, 0);
          _reply.readException();
        }
        finally {
          _reply.recycle();
          _data.recycle();
        }
      }
    }
    static final int TRANSACTION_startTunnel = (android.os.IBinder.FIRST_CALL_TRANSACTION + 0);
    static final int TRANSACTION_stopTunnel = (android.os.IBinder.FIRST_CALL_TRANSACTION + 1);
    static final int TRANSACTION_isTunnelActive = (android.os.IBinder.FIRST_CALL_TRANSACTION + 2);
    static final int TRANSACTION_initErrorReporting = (android.os.IBinder.FIRST_CALL_TRANSACTION + 3);
  }
  public static final java.lang.String DESCRIPTOR = "com.example.vpncn2_app.IVpnTunnelService";
  /**
   * Establishes a system-wide VPN connected to a remote Outline proxy server.
   * All device traffic is routed as follows:
   *  |VPN TUN interface| <-> |outline-go-tun2socks| <-> |Outline server|.
   * 
   * This method can be called multiple times with different configurations. The VPN will not be
   * torn down. Broadcasts an intent with action OutlinePlugin.Action.START and an error code
   * extra with the result of the operation, as defined in OutlinePlugin.ErrorCode. Displays a
   * persistent notification for the duration of the tunnel.
   * 
   * @param config tunnel configuration parameters.
   * @param isAutoStart boolean whether the tunnel was started without user intervention.
   * @return error code as defined in OutlinePlugin.ErrorCode.
   */
  public com.example.vpncn2_app.DetailedJsonError startTunnel(com.example.vpncn2_app.TunnelConfig config) throws android.os.RemoteException;
  /**
   * Tears down a tunnel started by calling `startTunnel`. Stops tun2socks, Outline, and
   * the system-wide VPN.
   * 
   * @param tunnelId unique identifier for the tunnel.
   * @return error code representing whether the operation was successful.
   */
  public com.example.vpncn2_app.DetailedJsonError stopTunnel(java.lang.String tunnelId) throws android.os.RemoteException;
  /**
   * Determines whether a tunnel has been started.
   * 
   * @param tunnelId unique identifier for the tunnel.
   * @return boolean indicating whether the tunnel is active.
   */
  public boolean isTunnelActive(java.lang.String tunnelId) throws android.os.RemoteException;
  /**
   * Initializes the error reporting framework on the VPN service process.
   * 
   * @param apiKey Sentry API key.
   */
  public void initErrorReporting(java.lang.String apiKey) throws android.os.RemoteException;
  /** @hide */
  static class _Parcel {
    static private <T> T readTypedObject(
        android.os.Parcel parcel,
        android.os.Parcelable.Creator<T> c) {
      if (parcel.readInt() != 0) {
          return c.createFromParcel(parcel);
      } else {
          return null;
      }
    }
    static private <T extends android.os.Parcelable> void writeTypedObject(
        android.os.Parcel parcel, T value, int parcelableFlags) {
      if (value != null) {
        parcel.writeInt(1);
        value.writeToParcel(parcel, parcelableFlags);
      } else {
        parcel.writeInt(0);
      }
    }
  }
}
