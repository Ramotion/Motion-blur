#include <metal_stdlib>
#include <CoreImage/CoreImage.h>
using namespace metal;


extern "C" {
    
    float4 motionDistorsion(coreimage::sampler source,
                            float2 translation,
                            float samplesCount,
                            float radius,
                            float scale,
                            coreimage::destination dest) {
        
        int isc = int(floor(samplesCount));
        float4 sum = float4(0.0);
        float2 offset = -translation;
        for (int i = 0; i < (isc * 2 + 1); i++) {
        
            float2 textureCoord = source.transform(dest.coord() + offset);
            float textureCoordY = textureCoord[1];
            float2 pixelCoord = textureCoord * source.size();
            float2 center = source.size() / 2;
            float dist = distance(pixelCoord, center);
            
            if (dist < radius) {
                pixelCoord -= center;
                float percent = 1.0 - ((radius - dist) / radius) * scale;
                percent = percent * percent;
                
                pixelCoord = pixelCoord * percent;
                pixelCoord += center;
                
                textureCoord = pixelCoord / source.size();
                textureCoord[1] = textureCoordY;
            }
            
            sum += source.sample(textureCoord);
            offset += translation / float(isc);
        }
        
        return sum / float((isc * 2 + 1));
    }
}
