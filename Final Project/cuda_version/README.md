Cuda Version
```
 Usage:   ./serial_m <image_filename> <filter_filename> <mode> 
```
mode==0時 為一般的GPU版本的convolution，圖片與filter都在global
mode==1時 與mode0相比，將filter搬到 constant memory，以求加速
mode==2時 與mode0相比，將圖片移入 shared memory
mode==3時 將圖片移入 shared memory 且 filter移入constant memory

目前每個block是16x16 ，限制是的block僅能 nxn
