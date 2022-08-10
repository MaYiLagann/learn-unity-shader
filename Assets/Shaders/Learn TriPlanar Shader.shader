Shader "Learn Unity Shader/Learn Triplanar"
{
    Properties
    {
        [NoScaleOffset]_MainTex ("Albedo (RGB)", 2D) = "white" {}
        _MainTexUV ("TileU, TileV, OffsetU, OffsetV", Vector) = (1,1,0,0)
        [NoScaleOffset]_MainTex2 ("Albedo Side (RGB)", 2D) = "white" {}
        _MainTex2UV ("TileU, TileV, OffsetU, OffsetV", Vector) = (1,1,0,0)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        // Physically based lambert lighting model, and enable shadows on all light types
        #pragma surface surf Lambert noambient

        sampler2D _MainTex;
        sampler2D _MainTex2;
        float4 _MainTexUV;
        float4 _MainTex2UV;

        struct Input
        {
            float3 worldPos;
            float3 worldNormal;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            // Create TriUV
            float2 topUV = float2 (IN.worldPos.x, IN.worldPos.z);
            float2 frontUV = float2 (IN.worldPos.x, IN.worldPos.y);
            float2 sideUV = float2 (IN.worldPos.z, IN.worldPos.y);

            // Textures
            fixed4 topTex = tex2D (_MainTex, topUV * _MainTexUV.xy + _MainTexUV.zw);
            fixed4 frontTex = tex2D (_MainTex2, frontUV * _MainTex2UV.xy + _MainTex2UV.zw);
            fixed4 sideTex = tex2D (_MainTex2, sideUV * _MainTex2UV.xy + _MainTex2UV.zw);

            fixed3 result = lerp(topTex, frontTex, abs(IN.worldNormal.z));
            result = lerp(result, sideTex, abs(IN.worldNormal.x));

            o.Albedo = result;
            o.Alpha = topTex.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
