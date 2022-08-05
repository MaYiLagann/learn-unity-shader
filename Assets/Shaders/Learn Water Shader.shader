Shader "Learn Unity Shader/Learn Water Reflection"
{
    Properties
    {
        _BumpMap ("Normal Map", 2D) = "bump" {}
        _Cube ("Cubemap", Cube) = "" {}
        _SPColor("Specular Color", Color) = (1,1,1,1)
        _SPPower("Specular Power", Range(0, 300)) = 150
        _SPMulti("Specular Multiply", Range(1, 10)) = 3
        _WaveH("Wave Height", Range(0, 0.5)) = 0.1
        _WaveL("Wave Length", Range(5, 20)) = 12
        _WaveT("Wave Timing", Range(0, 10)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }

        CGPROGRAM
        #pragma surface surf WaterSpecular noambient alpha:fade vertex:vert

        sampler2D _BumpMap;
        samplerCUBE _Cube;
        float4 _SPColor;
        float _SPPower;
        float _SPMulti;
        float _WaveH;
        float _WaveL;
        float _WaveT;

        struct Input
        {
            float2 uv_BumpMap;
            float3 worldRefl;
            float3 viewDir;
            INTERNAL_DATA
        };

        void vert (inout appdata_full v)
        {
            float movement = 0;

            movement += sin(abs((v.texcoord.x * 4 - 2) * _WaveL) * _Time.y * _WaveT) * _WaveH;
            movement += sin(abs((v.texcoord.y * 4 - 2) * _WaveL) * _Time.y * _WaveT) * _WaveH;
            movement /= 2;

            v.vertex.y += movement;
        }

        void surf (Input IN, inout SurfaceOutput o)
        {
            float3 normal1 = UnpackNormal(tex2D (_BumpMap, IN.uv_BumpMap + _Time.x * 0.2));
            float3 normal2 = UnpackNormal(tex2D (_BumpMap, IN.uv_BumpMap - _Time.x * 0.2));
            o.Normal = (normal1 + normal2) / 2;

            // Rim term
            float4 re = texCUBE (_Cube, WorldReflectionVector(IN, o.Normal));
            float rim = saturate(dot(o.Normal, IN.viewDir));
            rim = pow(1 - rim, 1.5);

            o.Emission = re * rim;
            o.Alpha = saturate(rim * 0.5);
        }

        float4 LightingWaterSpecular(SurfaceOutput s, float3 lightDir, float3 viewDir, float atten)
        {
            // Specular term
            float3 height = normalize(lightDir + viewDir);
            float spec = saturate(dot(height, s.Normal));
            spec = pow(spec, _SPPower);

            // Final term
            float4 finalColor;
            finalColor.rgb = spec * _SPColor.rgb * _SPMulti;
            finalColor.a = s.Alpha + spec;

            return finalColor;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
