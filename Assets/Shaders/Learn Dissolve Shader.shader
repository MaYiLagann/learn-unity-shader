Shader "Learn Unity Shader/Learn Dissolve"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _NoiseTex ("Noise Texture", 2D) = "white" {}
        _Cut ("Alpha Cutoff", Range(0, 1)) = 0
        [HDR]_OutColor ("Outline Color", Color) = (1,1,1,1)
        _OutThickness ("Outline thickness", Range(1, 1.15)) = 1.15
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }

        CGPROGRAM
        #pragma surface surf Lambert alpha:fade

        sampler2D _MainTex;
        sampler2D _NoiseTex;
        float _Cut;
        float4 _OutColor;
        float _OutThickness;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_NoiseTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            float4 noise = tex2D (_NoiseTex, IN.uv_NoiseTex);

            o.Albedo = c.rgb;

            float alpha;
            if (noise.r >= _Cut)
            alpha = 1;
            else
            alpha = 0;

            float outline;
            if (noise.r >= _Cut * _OutThickness)
            outline = 0;
            else
            outline = 1;

            o.Emission = outline * _OutColor.rgb;
            o.Alpha = alpha;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
