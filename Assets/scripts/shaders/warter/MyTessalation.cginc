#if !defined(TESSELLATION_INCLUDED)
#define TESSELLATION_INCLUDED

#endif

#include "UnityCG.cginc"
// #include "MyVertex.cginc"

struct TessellationFactors {
    float edge[3] : SV_TessFactor;
    float inside : SV_InsideTessFactor;
};

struct TessellationControlPoint {
	float4 vertex : INTERNALTESSPOS;
	float3 normal : NORMAL;
	float4 tangent : TANGENT;
	float2 uv : TEXCOORD0;
};

[UNITY_domain("tri")]
[UNITY_outputcontrolpoints(3)]
[UNITY_outputtopology("triangle_cw")]
// [UNITY_partitioning("integer")]
[UNITY_partitioning("fractional_odd")]
[UNITY_patchconstantfunc("MyPatchConstantFunction")]
TessellationControlPoint MyHullProgram (InputPatch<TessellationControlPoint, 3> patch, uint id : SV_OutputControlPointID) {
    return patch[id];
}

float TessellationEdgeFactor (float3 p0, float3 p1) {
	float edgeLength = distance(p0, p1);

	float3 edgeCenter = (p0 + p1) * 0.5;
	float viewDistance = pow(distance(edgeCenter, _WorldSpaceCameraPos), _TessDistPow);

	float tess = edgeLength / (_TessellationEdgeLength * viewDistance)/100.0;

	if (tess < 3.0) {
		tess = 3.0;
	}

	return tess;
}

TessellationFactors MyPatchConstantFunction (InputPatch<TessellationControlPoint, 3> patch) {
	float tess = _Tess;

	float3 p0 = mul(unity_ObjectToWorld, patch[0].vertex).xyz;
	float3 p1 = mul(unity_ObjectToWorld, patch[1].vertex).xyz;
	float3 p2 = mul(unity_ObjectToWorld, patch[2].vertex).xyz;

	TessellationFactors f;
    f.edge[0] = TessellationEdgeFactor(p1, p2);
    f.edge[1] = TessellationEdgeFactor(p2, p0);
    f.edge[2] = TessellationEdgeFactor(p0, p1);
	f.inside = (TessellationEdgeFactor(p1, p2) + TessellationEdgeFactor(p2, p0) + TessellationEdgeFactor(p0, p1)) * (1 / 3.0);

	return f;
}

[UNITY_domain("tri")]
vertOut MyDomainProgram (TessellationFactors factors, OutputPatch<appdata_tan, 3> patch, float3 barycentricCoordinates : SV_DomainLocation) {
    appdata_tan data;
    #define MY_DOMAIN_PROGRAM_INTERPOLATE(fieldName) data.fieldName = \
		patch[0].fieldName * barycentricCoordinates.x + \
		patch[1].fieldName * barycentricCoordinates.y + \
		patch[2].fieldName * barycentricCoordinates.z;

	MY_DOMAIN_PROGRAM_INTERPOLATE(vertex)
    MY_DOMAIN_PROGRAM_INTERPOLATE(normal)
	MY_DOMAIN_PROGRAM_INTERPOLATE(tangent)
	MY_DOMAIN_PROGRAM_INTERPOLATE(texcoord)

    return vertexProgram(data);
}

TessellationControlPoint MyTessellationVertexProgram (appdata_tan v) {
    TessellationControlPoint p;
	p.vertex = v.vertex;
	p.normal = v.normal;
	p.tangent = v.tangent;
	p.uv = v.texcoord;
	return p;
}
