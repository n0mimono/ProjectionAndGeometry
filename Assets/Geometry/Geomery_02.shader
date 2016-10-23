Shader "Geometry_02" {
  Properties {
    _MainTex ("Texture", 2D) = "white" {}
    _Color ("Color", Color) = (1,1,1,1)
  }
  SubShader {
    Tags { "RenderType"="Transparent" "Queue"="Transparent" }
    Cull Off
    Blend SrcAlpha OneMinusSrcAlpha
    LOD 100

    Pass {
      CGPROGRAM
      #pragma target 4.0
      #pragma vertex vert
      #pragma geometry geo
      #pragma fragment frag
      #pragma multi_compile_fog
      #include "UnityCG.cginc"

      struct appdata {
        float4 vertex : POSITION;
        float2 uv     : TEXCOORD0;
        float3 normal : TEXCOORD1;
      };

      struct v2g {
        float4 vertex : POSITION;
        float2 uv     : TEXCOORD0;
        float3 normal : TEXCOORD1;
      };

      struct g2f {
        float4 vertex : SV_POSITION;        
        float2 uv     : TEXCOORD0;
        float4 color  : TEXCOORD1;
        UNITY_FOG_COORDS(2)
      };

      sampler2D _MainTex;
      float4 _MainTex_ST;
      float4 _Color;
      
      v2g vert (appdata v) {
        v2g o;
        o.vertex = v.vertex;
        o.uv     = v.uv;
        o.normal = v.normal;
        return o;
      }

      [maxvertexcount(6)]
      void geo(triangle v2g v[3], inout TriangleStream<g2f> TriStream) {
        for (int i = 0; i < 3; i++) {
          g2f o;
          o.vertex = mul(UNITY_MATRIX_MVP, v[i].vertex);
          o.uv     = TRANSFORM_TEX(v[i].uv, _MainTex);
          o.color  = float4(1,1,1,1);
          UNITY_TRANSFER_FOG(o,o.vertex);
          TriStream.Append(o);
        }
        TriStream.RestartStrip();

        for (int i = 0; i < 3; i++) {
          g2f o;
          v[i].vertex.xyz *= 1.1;
          o.vertex = mul(UNITY_MATRIX_MVP, v[i].vertex);
          o.uv     = TRANSFORM_TEX(v[i].uv, _MainTex);
          o.color  = float4(1,1,1,0.5);
          UNITY_TRANSFER_FOG(o,o.vertex);
          TriStream.Append(o);
        }
        TriStream.RestartStrip();
      }

      fixed4 frag (g2f i) : SV_Target {
        fixed4 col = tex2D(_MainTex, i.uv) * i.color * _Color;
        UNITY_APPLY_FOG(i.fogCoord, col);
        return col;
      }
      ENDCG
    }
  }
}
