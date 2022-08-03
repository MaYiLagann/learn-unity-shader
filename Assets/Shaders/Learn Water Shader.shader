Shader "Learn Unity Shader/Learn Water Reflection"
{
    Properties
    {
        _BumpMap ("Normal Map", 2D) = "bump" {}
        _Cube ("Cubemap", Cube) = "" {}
        _Alpha ("Alpha", Range(0,1)) = 0.2
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }

        CGPROGRAM
        #pragma surface surf Lambert noambient alpha:fade

        sampler2D _BumpMap;
        samplerCUBE _Cube;
        float _Alpha;

        struct Input
        {
            float2 uv_BumpMap;
            float3 worldRefl;
            float3 viewDir;
            INTERNAL_DATA
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            float3 normal1 = UnpackNormal(tex2D (_BumpMap, IN.uv_BumpMap + _Time.x * 0.2));
            float3 normal2 = UnpackNormal(tex2D (_BumpMap, IN.uv_BumpMap - _Time.x * 0.2));
            o.Normal = (normal1 + normal2) / 2;

            float4 re = texCUBE (_Cube, WorldReflectionVector(IN, o.Normal));
            float rim = saturate(dot(o.Normal, IN.viewDir));
            rim = pow(1 - rim, 1.5);
            o.Emission = re * rim * 2;
            o.Alpha = saturate(rim * 0.5);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
