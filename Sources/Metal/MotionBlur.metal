#include <metal_stdlib>
#include <CoreImage/CoreImage.h> /// includes CIKernelMetalLib.h
using namespace metal;


extern "C" {

    float4 motionBlur(coreimage::sampler source, float2 translation, float samplesCount, coreimage::destination dest) {
        
        int isc = int(floor(samplesCount));
        float2 dc = dest.coord();
        float4 sum = float4(0.0);
        float2 offset = -translation;
        for (int i = 0; i < (isc * 2 + 1); i++) {
            sum += source.sample(source.transform(dc + offset));
            offset += translation / float(isc);
        }
        
        return sum / float((isc * 2 + 1));
    }
}
