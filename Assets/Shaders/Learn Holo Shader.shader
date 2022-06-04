Shader "Learn Unity Shader/Learn Holo"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _RimColor ("Rim Color", Color) = (1,1,1,1)
        _RimPower ("Rim Power", Range(1,10)) = 1
        _BlinkSpeed ("Blink Speed", Range(1,10)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows alpha:fade

        sampler2D _MainTex;
        float4 _RimColor;
        float _RimPower;
        float _BlinkSpeed;

        struct Input
        {
            float2 uv_MainTex;
            float3 viewDir;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {

            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            // o.Albedo = c.rgb;
            o.Emission = _RimColor.rgb;
            float rim = saturate(dot(o.Normal, IN.viewDir));
            rim = pow(1 - rim, _RimPower);

            o.Alpha = rim * (sin(_Time.y * _BlinkSpeed) * 0.5 + 0.5);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
