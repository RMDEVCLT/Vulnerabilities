# Product Life Cycle for .NET CORE

Here's a summary of Microsoft Instructions so you don't have to read everything.

## Step A)
Upgrade .NET CORE to a supported version. Once you confirm with the developer the application works, proceed with Step B.

1. It is highly recommended you only install the Hosting Bundle for running your application.
2. If you need to develop, install the Hosting Bundle first and then your SDK. (Must be done in this order)

**Additional information:**
- Versions 2, 3, 5, 6, 7 are End Of Life as of 12/2024
- Version 8.x Supported 2024-2025

**Example:**
- Hosting bundle Link: [Download Hosting Bundle](https://dotnet.microsoft.com/en-us/download/dotnet/thank-you/runtime-aspnetcore-8.0.11-windows-hosting-bundle-installer)
- SDK Link: [Download SDK](https://dotnet.microsoft.com/en-us/download/dotnet/thank-you/sdk-8.0.404-windows-x64-installer)

## Step B)
After the supported version is proven to work by the APP Developer, uninstall previous versions.

**High-level Instructions:**

1. Download the Clean Uninstaller MSI from Microsoft.
   - [Download Uninstaller](https://github.com/dotnet/cli-lab/releases/download/1.7.550802/dotnet-core-uninstall-1.7.550802.msi)
2. List out all the versions of DotNetCore on your system.
   - Open CMD and type the following command:
     ```sh
     Dotnet-core-uninstall list
     ```
3. Uninstall the vulnerable version off the system.
   - (.NET could have 4 parts: `--aspnet-runtime`, `--hosting-bundle`, `--runtime`, `--sdk`)

**Example:** 
Key note to mention, the version 2.1.23 came from looking at the output from the previous command.
   ```sh
   dotnet-core-uninstall remove 2.1.23 --sdk --yes --verbosity d
   dotnet-core-uninstall remove 2.1.23 --runtime --yes --verbosity d
   dotnet-core-uninstall remove 2.1.23 --hosting-bundle --yes --verbosity d
   dotnet-core-uninstall remove 2.1.23 --aspnet-runtime --yes --verbosity d














