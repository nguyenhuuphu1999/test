// Copyright 2020 The Outline Authors
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package org.outline;

import android.os.Parcel;
import android.os.Parcelable;

/**
 * Tunnel configuration parameters for establishing a VPN connection.
 */
public class TunnelConfig implements Parcelable {
    public String id = "";
    public String name = "";
    public String transportConfig = "";

    public TunnelConfig() {}

    public TunnelConfig(String id, String name, String transportConfig) {
        this.id = id;
        this.name = name;
        this.transportConfig = transportConfig;
    }

    protected TunnelConfig(Parcel in) {
        id = in.readString();
        name = in.readString();
        transportConfig = in.readString();
    }

    public static final Creator<TunnelConfig> CREATOR = new Creator<TunnelConfig>() {
        @Override
        public TunnelConfig createFromParcel(Parcel in) {
            return new TunnelConfig(in);
        }

        @Override
        public TunnelConfig[] newArray(int size) {
            return new TunnelConfig[size];
        }
    };

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(id);
        dest.writeString(name);
        dest.writeString(transportConfig);
    }
}