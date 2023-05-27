using Pkg
# Pkg.add("ImageEdgeDetection")
# Pkg.add("Noise")
# Pkg.add("Images")
# Pkg.add("Plots")
# Pkg.add("ImageFiltering")
# Pkg.add("Random")
# Pkg.add("Statistics")
# Pkg.add("ImageEdgeDetection")
using Noise 
using Images
using Plots
using ImageFiltering
using Random
using Statistics
using ImageEdgeDetection
using ImageEdgeDetection: Percentile

img=load("blocks_bw.png")
σ1 = 1.2
img_gaussian = imfilter(img, Kernel.gaussian(σ1))
plot_image(I; kws...) = plot(I; aspect_ratio=:equal, size=size(I), framestyle=:none, kws...)
img_plot1=plot_image(img_gaussian)
img_real=plot_image(img)
display(plot(img_real,img_plot1; size=(700, 700), layout=@layout [x; x]))
Gx, Gy = imgradients(img_gaussian, KernelFactors.sobel) 
println(size(Gx))
println(size(img))
t=0.01
G=.√(Gx.^2+Gy.^2).>t;
plot(
    plot_image(img; title="block_pw"), 
    plot_image(Gray.(G); title="edges"),
    layout = @layout([x;x]),
    size = (500, 500)
    )
G_thin=thinning(G)
display(plot(plot_image(Gray.(G); title="Thick square"), 
plot_image(Gray.(G_thin); title="Thin square"), size=(500, 250)))
alg = Canny(spatial_scale=3, high=Percentile(80), low=Percentile(10))
img_canny = detect_edges(img, alg)

display(mosaicview(img, img_canny, nrow=1))

# Using a gaussian filter and threshold are two parameters that can help us to find the edges. If we do not use the gaussian filter, finding the threshold might become a hard process.
# Also, there is a chance that some other parts of an Image that are not the edges; be detected as the edges. So, using the gaussian filter makes easier to distinguish edges from other parts.
# Thinning is also a necessary part of edge detection since it makes the lines of detected edges thinner and edge detection more exact.

#As we can see, Canny edge detection is much better and more precise.


