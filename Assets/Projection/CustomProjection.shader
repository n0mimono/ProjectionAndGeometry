Shader "CustomProjection" {
  Properties {
    _MainTex ("Texture", 2D) = "white" {}
    _ProjectionLerp ("Projection Lerp", Range(0, 1)) = 1 
    [Toggle] _UseBasicProjection ("Use Basic Projection", Float) = 1
  }
  SubShader {
    Tags { "RenderType"="Opaque" }
    LOD 100

    Pass {
      CGPROGRAM
      #pragma vertex vert
      #pragma fragment frag
      #pragma multi_compile_fog
      #include "UnityCG.cginc"

      float4x4 _PersProj;
      float4x4 _OrthProj;
      float _ProjectionLerp;
      float _UseBasicProjection;

      sampler2D _MainTex;
      float4 _MainTex_ST;

      struct appdata {
        float4 vertex : POSITION;
        float2 uv : TEXCOORD0;
      };

      struct v2f {
        float2 uv : TEXCOORD0;
        UNITY_FOG_COORDS(1)
        float4 vertex : SV_POSITION;
      };

      v2f vert (appdata v) {
        v2f o;

        float4x4 proj = lerp(_OrthProj, _PersProj, _ProjectionLerp);
        if (_UseBasicProjection == 1) {
          proj = UNITY_MATRIX_P;
        }
        float4x4 view  = UNITY_MATRIX_V;
        fixed4x4 vp    = mul(proj, view);

        o.vertex = mul(vp, mul(unity_ObjectToWorld, v.vertex));
        o.uv = TRANSFORM_TEX(v.uv, _MainTex);
        UNITY_TRANSFER_FOG(o,o.vertex);
        return o;
      }

      fixed4 frag (v2f i) : SV_Target {
        fixed4 col = tex2D(_MainTex, i.uv);
        col.rgb = col.r > 0.99 ? 1 : 0;

        UNITY_APPLY_FOG(i.fogCoord, col);
        return col;
      }
      ENDCG
    }
  }
}
