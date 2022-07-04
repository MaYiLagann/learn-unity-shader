Shader "Learn Unity Shader/Learn Depth"
{
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Lambert noambient noshadow

        sampler2D _CameraDepthTexture;

        struct Input
        {
            float4 screenPos;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            float2 sPos = float2(IN.screenPos.x, IN.screenPos.y);
            if (IN.screenPos.w != 0)
            {
                sPos /= IN.screenPos.w;
            }
            float2 Depth = tex2D(_CameraDepthTexture, sPos);

            o.Emission = Depth.r * 100;
            o.Alpha = 1;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
