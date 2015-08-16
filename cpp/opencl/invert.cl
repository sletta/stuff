__constant sampler_t sampler = CLK_NORMALIZED_COORDS_FALSE | CLK_ADDRESS_CLAMP_TO_EDGE | CLK_FILTER_LINEAR;

__kernel void inverter(__read_only image2d_t source, __write_only image2d_t target)
{
#if 1
    float2 pos = { get_global_id(0), get_global_id(1) };
    float4 pixel =
          read_imagef(source, sampler, (float2)(pos.x + 0.5f, pos.y + 0.5f))
        + read_imagef(source, sampler, (float2)(pos.x - 0.5f, pos.y + 0.5f))
        + read_imagef(source, sampler, (float2)(pos.x + 0.5f, pos.y - 0.5f))
        + read_imagef(source, sampler, (float2)(pos.x - 0.5f, pos.y - 0.5f))
        ;
    write_imagef(target, (int2)(pos.x, pos.y), pixel * 9.0f / 4.0f);

    /*
        Running at: 101 us
     */
#endif

#if 0
    int2 pos = { get_global_id(0), get_global_id(1) };
    float4 pixel =
          read_imagef(source, sampler, pos + (int2)(+1, +1))
        + read_imagef(source, sampler, pos + (int2)(+0, +1))
        + read_imagef(source, sampler, pos + (int2)(-1, +1))
        + read_imagef(source, sampler, pos + (int2)(+1,  0))
        + read_imagef(source, sampler, pos + (int2)( 0,  0))
        + read_imagef(source, sampler, pos + (int2)(-1,  0))
        + read_imagef(source, sampler, pos + (int2)(+1, -1))
        + read_imagef(source, sampler, pos + (int2)( 0, -1))
        + read_imagef(source, sampler, pos + (int2)(-1, -1))
        ;
    write_imagef(target, (int2)(pos.x, pos.y), pixel);

    /*
        Running at: 163 ms
     */
#endif

#if 0
    int2 pos = { get_global_id(0), get_global_id(1) };
    float4 pixel =
          read_imagef(source, sampler, (int2)(pos.x + 1, pos.y + 1))
        + read_imagef(source, sampler, (int2)(pos.x    , pos.y + 1))
        + read_imagef(source, sampler, (int2)(pos.x - 1, pos.y + 1))
        + read_imagef(source, sampler, (int2)(pos.x + 1, pos.y))
        + read_imagef(source, sampler, pos)
        + read_imagef(source, sampler, (int2)(pos.x - 1, pos.y))
        + read_imagef(source, sampler, (int2)(pos.x + 1, pos.y - 1))
        + read_imagef(source, sampler, (int2)(pos.x    , pos.y - 1))
        + read_imagef(source, sampler, (int2)(pos.x - 1, pos.y - 1))
        ;
    write_imagef(target, (int2)(pos.x, pos.y), pixel);

    /*
        Running at: 163 ms
     */
#endif

}