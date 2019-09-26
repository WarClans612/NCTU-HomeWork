
## Install OpenCV
- Use OpenCV 3.4.0
- Follow this page to install opencv at your computer [OpenCV install in Linux](https://docs.opencv.org/3.4.0/d7/d9f/tutorial_linux_install.html)

## Compile
This project uses cmake to build. You can use `build.sh` to compile in simple way.
```bash
./build.sh
```

After compiling, you can find the serial program named `serial_m` at current directory.

## Run
```bash
./serial_m <image_filename> <filter_filename>
```

*image_filename* is the image file you want to run

*filter_filename* is the filter file, the file format is:

```
M                # the number of filter matrix
N1               # the size of this filter matrix
n11 n12 n13 ...  # there is N*N integer at one line, seperated by whitesapce
N2
n21 n22 n23 ...
...
```

You can read `filter.txt` as the example.
