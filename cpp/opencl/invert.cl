__constant sampler_t sampler = CLK_NORMALIZED_COORDS_FALSE | CLK_ADDRESS_CLAMP_TO_EDGE | CLK_FILTER_NEAREST;

__kernel void inverter(__read_only image2d_t source, __write_only image2d_t target)
{
    const int2 pos = { get_global_id(0), get_global_id(1) };
    float4 pixel = read_imagef(source, sampler, pos);
    float4 invPixel = 1.0f - pixel;
    write_imagef(target, pos, invPixel);
}