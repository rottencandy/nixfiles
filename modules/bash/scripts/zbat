#!/usr/bin/env bash

DBUS_CONN="org.bluez"
DBUS_PATH="/org/bluez/hci0"
DBUS_GET_PROP="org.freedesktop.DBus.Properties.Get"

BATTERY_UUID="0000180f-0000-1000-8000-00805f9b34fb"
BATTERY_LEVEL_UUID="00002a19-0000-1000-8000-00805f9b34fb"
BATTERY_USER_DESC="00002901-0000-1000-8000-00805f9b34fb"

DEVICES=$(gdbus introspect \
    --system \
    --only-properties \
    --dest "$DBUS_CONN" \
    --object-path "$DBUS_PATH" \
    | grep -o 'dev_[A-Z0-9_]*'
)

if [[ -z "$DEVICES" ]]; then
    echo "No device connected"
    exit 1
fi

readarray -t DEVICES_ARR <<< "$DEVICES"

for ID in "${DEVICES_ARR[@]}"; do
    DEVICE_PATH="$DBUS_PATH/$ID"
    CONNECTED=$(
    gdbus call \
        --system \
        --dest "$DBUS_CONN" \
        --object-path "$DEVICE_PATH" \
        --method "$DBUS_GET_PROP" \
        "org.bluez.Device1" \
        "Connected" \
        | grep -o '\(\<.*\>\)'
    )
    if [ "$CONNECTED" = "false" ]; then
        continue
    fi

    NAME=$(
    gdbus call \
        --system \
        --dest "$DBUS_CONN" \
        --object-path "$DEVICE_PATH" \
        --method "$DBUS_GET_PROP" \
        "org.bluez.Device1" \
        "Alias" \
        | grep -o '\(\<.*\>\)'
    )

    echo "$NAME ($ID):"

    CHILD_PATHS=$(
    gdbus introspect \
        --system \
        --only-properties \
        --dest "$DBUS_CONN" \
        --object-path "$DEVICE_PATH" \
        | grep -o 'service00..'
    )

    readarray -t CHILD_PATHS_ARR <<< "$CHILD_PATHS"

    for SVC in "${CHILD_PATHS_ARR[@]}"; do
        UUID=$(
        gdbus call \
            --system \
            --dest "$DBUS_CONN" \
            --object-path "$DEVICE_PATH/$SVC" \
            --method "$DBUS_GET_PROP" \
            "org.bluez.GattService1" \
            "UUID" \
            | grep -o '\(\<.*\>\)'
        )
        if [ "$UUID" != "$BATTERY_UUID" ]; then
            continue
        fi
        CHILD_PATHS=$(
        gdbus introspect \
            --system \
            --only-properties \
            --dest "$DBUS_CONN" \
            --object-path "$DEVICE_PATH/$SVC" \
            | grep -o 'char00..'
        )
        readarray -t CHILD_PATHS_ARR <<< "$CHILD_PATHS"

        for CHR in "${CHILD_PATHS_ARR[@]}"; do
            UUID=$(
            gdbus call \
                --system \
                --dest "$DBUS_CONN" \
                --object-path "$DEVICE_PATH/$SVC/$CHR" \
                --method "$DBUS_GET_PROP" \
                "org.bluez.GattCharacteristic1" \
                "UUID" \
                | grep -o '\(\<.*\>\)'
            )
            if [ "$UUID" != "$BATTERY_LEVEL_UUID" ]; then
                continue
            fi
            VALUE=$(
            gdbus call \
                --system \
                --dest "$DBUS_CONN" \
                --object-path "$DEVICE_PATH/$SVC/$CHR" \
                --method org.bluez.GattCharacteristic1.ReadValue \
                {} \
                | grep -o '0x..' \
                | sed 's/0x//g'
            )
            CHILD_PATHS=$(
            gdbus introspect \
                --system \
                --only-properties \
                --dest "$DBUS_CONN" \
                --object-path "$DEVICE_PATH/$SVC/$CHR" \
                | grep -o 'desc00..'
            )
            readarray -t CHILD_PATHS_ARR <<< "$CHILD_PATHS"

            for DESC in "${CHILD_PATHS_ARR[@]}"; do
                UUID=$(
                gdbus call \
                    --system \
                    --dest "$DBUS_CONN" \
                    --object-path "$DEVICE_PATH/$SVC/$CHR/$DESC" \
                    --method "$DBUS_GET_PROP" \
                    "org.bluez.GattDescriptor1" \
                    "UUID" \
                    | grep -o '\(\<.*\>\)'
                )
                if [ "$UUID" = "$BATTERY_USER_DESC" ]; then
                    TYPE="peripheral"
                else
                    TYPE="central"
                fi
            done
            echo "$((16#$VALUE)) $TYPE"
        done
    done
done
