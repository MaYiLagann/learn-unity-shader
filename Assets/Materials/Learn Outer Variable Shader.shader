Shader "Learn Outer Variable"
{
    Properties
    {
        _Red ("Color Red", Range(0,1)) = 0
        _Green ("Color Green", Range(0,1)) = 0
        _Blue ("Color Blue", Range(0,1)) = 0
        _BrightDark ("Brightness & Darkness", Range(-1,1)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows noambient

        struct Input
        {
            float4 color : Color;
        };

        float _Red;
        float _Blue;
        float _Green;
        float _BrightDark;

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            o.Albedo = float3(_Red, _Green, _Blue) + _BrightDark;

            o.Alpha = 1;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
