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
 * Detailed error information containing error code and JSON error details.
 */
public class DetailedJsonError implements Parcelable {
    public String code = "";
    public String errorJson = "";

    public DetailedJsonError() {}

    public DetailedJsonError(String code, String errorJson) {
        this.code = code;
        this.errorJson = errorJson;
    }

    protected DetailedJsonError(Parcel in) {
        code = in.readString();
        errorJson = in.readString();
    }

    public static final Creator<DetailedJsonError> CREATOR = new Creator<DetailedJsonError>() {
        @Override
        public DetailedJsonError createFromParcel(Parcel in) {
            return new DetailedJsonError(in);
        }

        @Override
        public DetailedJsonError[] newArray(int size) {
            return new DetailedJsonError[size];
        }
    };

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(code);
        dest.writeString(errorJson);
    }
}