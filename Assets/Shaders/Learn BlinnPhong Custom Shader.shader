Shader "Learn Unity Shader/Learn BlinnPhong Custom"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _BumpMap ("Normal Map", 2D) = "bump" {}
        _GlossTex ("Gloss Map", 2D) = "white" {}
        _SpecColor ("Specular Color", color) = (1,1,1,1)
        _SpecPower ("Specular Power", Range(10, 200)) = 100
        _RimColor ("Rim Color", Color) = (1,1,1,1)
        _RimPower ("Rim Power", Range(1,10)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        // Physically based test lighting model, and enable shadows on all light types
        #pragma surface surf Test

        sampler2D _MainTex;
        sampler2D _BumpMap;
        sampler2D _GlossTex;
        float _SpecPower;
        float4 _RimColor;
        float _RimPower;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
            float2 uv_GlossTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
            float4 m = tex2D(_GlossTex, IN.uv_GlossTex);

            o.Albedo = c.rgb;
            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
            o.Gloss = m.a;
            o.Alpha = c.a;
        }

        float4 LightingTest (SurfaceOutput s, float3 lightDir, float3 viewDir, float atten)
        {
            float4 final;

            float3 DiffColor;
            float ndot1 = saturate(dot(s.Normal, lightDir));
            DiffColor = ndot1 * s.Albedo * _LightColor0.rgb * atten;

            // Spec term
            float3 SpecColor;
            float3 H = normalize(lightDir + viewDir);
            float spec = saturate(dot(H, s.Normal));
            spec = pow(spec, _SpecPower);
            SpecColor = spec * _SpecColor.rgb * s.Gloss;

            // Rim term
            float3 rimColor;
            float rim = abs(dot(viewDir, s.Normal));
            float invrim = 1 - rim;
            rimColor = pow(invrim, _RimPower) * _RimColor.rgb;

            // Final term
            final.rgb = DiffColor.rgb + SpecColor.rgb + rimColor.rgb;
            final.a = s.Alpha;

            return final;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
