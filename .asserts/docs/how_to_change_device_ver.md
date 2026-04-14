In Gowin EDA, changing the target device and its version is a common operation during project migration. You can follow the steps below to complete this process:

![how_to_change_device_ver](../pics/how_to_change_device_ver.png)

-----

#### **1. Enter the Device Configuration Interface**

In the **Design** window on the left side of the IDE, locate the top-level project node. Double-click the row with the **green chip icon** (this row typically displays the current full part number, such as `GW5AST-LV138...`).

#### **2. Select the New Device**

In the **Device Selection** window that appears:

  * **Series/Device:** Select the target chip series and specific model.
  * **Package/Speed:** Confirm the package type and speed grade.
  * Click **OK** once confirmed. The project will then automatically associate with the library files for the new device.

#### **3. [Reconfigure and Regenerate IP Cores (Critical Step)](./how_to_regenerate_IP.md)**

Since hardware architectures (such as PLLs, memory units, and SerDes) vary across different chip models, you **must manually refresh your IPs**.

#### **4. Re-run the Design Flow**

After changing the hardware and refreshing the IPs, you need to run the following processes in order:

1.  **Synthesize**
2.  **Place & Route**
3.  **Produce Device Video/Bitstream** (Generate bitstream)

-----

### **Important Notes**

  * **Compatibility Check:** Some IPs supported by certain chip models may be deprecated or replaced by alternatives in other series (e.g., migrating from GW2A to GW5A). Always verify if the IP is still available for the new device.
  * **Pin Constraints:** After changing the device, physical pin definitions (the `.cst` file) usually become invalid or require adjustment. Be sure to re-check your pin assignments in the **FloorPlanner**.

