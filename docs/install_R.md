# Installation

The user will need RStatistics and RStudio to be able to run these scripts. Below are instructions for downloading these interfaces. 

## Download R software: 

### To install R on Windows OS:

1. Go to the CRAN website (https://cran.r-project.org/).
2. Click on "Download R for Windows".
3. Click on "install R for the first time" link to download the R executable (.exe) file.
4. From your downloads folder, run the R executable file to start installation, and allow the app to make changes to your device.
5. Select the installation language.
6. Follow the installation instructions.
7. Click on "Finish" to exit the installation setup.
8. R has now been successfully installed on your Windows OS. Open the R GUI to start writing R codes.

### Installing R on MacOS X:
Installing R on MacOS X is very similar to installing R on Window OS. The difference is the file format that you have to download. The procedure is as follows:

1. Go to the CRAN website (https://cran.r-project.org/).
2. Click on "Download R for macOS". 
3. Download the latest version of the R GUI under (.pkg file) under "Latest release". You can download much older versions by following the "old directory" or "CRAN archive" links. NOTE: if you have a mac that is operating on MacOS 12 or earlier, select the "For older Intel Macs" executable.
4. From your downloads folder, run the .pkg file, and follow the installation instructions.

## Download RStudio: 

Installing RStudio Desktop:

1. Go to the RStudio website (https://posit.co/download/rstudio-desktop/).
2. Scroll down to the "All Installers and Tarballs" section. 
3. Click on the download link specific to your operating system (OS). 

NOTE: If you have Mac OS 12 or earlier, you will need to download an older, unsupported version of R Studio. Visit https://forum.posit.co/t/rstudio-desktop-releases-on-unsupported-versions-of-macos/176074 and select the installer that corresponds to your OS version.

4. From your downloads folder, run the RStudio Executable file (.exe) for Windows OS or the Apple Image Disk file (.dmg) for macOS X.
5. Follow the installation instructions to complete RStudio Desktop installation.
6. RStudio is now successfully installed on your computer.

## Download GitHub Repository
Now that you have these software, you will be able to run the scripts on our repository to manipulate the provided participant level data. First, you will need to download the repository to your local computer. This can be done in a number of ways, but for a first time user we recommend downloading as a zip file. 

Downloading the GitHub repository: 

1. Scroll to the top of this repository. 
2. Next, click on the green "Code <>" button at the top right. 
3. From the dropdown menu, select "Download ZIP" at the bottom. This will download the entire repository to your downloads folder. 
4. Navigate to your downloads folder. Select the zipped "HBCD-EEG-data-release-notes-main" folder by left clicking. Right click. 
5. Select the "Extract all" option from the drop down menu. This will unzip the repository to your downloads folder. 

## Navigating Folder Structure
Now, we will outline how to navigate your folder structure. The EEG data will be downloaded to a folder within a folder of all other outputs you download off of Lasso. To navigate to the EEG data to be used in the below scripts, in your Lasso download, navigate to the "bids > derivatives > made" folder. This should be a folder with folders named "sub-{unique ID}". Use the path to this folder as the directory path in each of the provided R Studio scripts.

