Shader "Learn Unity Shader/Learn BlinnPhong Custom"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _BumpMap ("Normal Map", 2D) = "bump" {}
        _SpecColor ("Specular Color", color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        // Physically based test lighting model, and enable shadows on all light types
        #pragma surface surf Test noambient

        sampler2D _MainTex;
        sampler2D _BumpMap;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);

            o.Albedo = c.rgb;
            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
            o.Alpha = c.a;
        }

        float4 LightingTest (SurfaceOutput s, float3 lightDir, float3 viewDir, float atten)
        {
            float4 final;

            float3 DiffColor;
            float ndot1 = saturate(dot(s.Normal, lightDir));
            DiffColor = ndot1 * s.Albedo * _LightColor0.rgb * atten;

            // Spec term
            float3 H = normalize(lightDir + viewDir);
            float spec = saturate(dot(H, s.Normal));

            return pow(spec, 100);

            final.rgb = DiffColor.rgb;
            final.a = s.Alpha;

            return final;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
