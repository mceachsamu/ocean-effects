#if !defined(FLAT_WIREFRAME_INCLUDED)
#define FLAT_WIREFRAME_INCLUDED

[maxvertexcount(3)]
void MyGeometryProgram (triangle vertOut i[3], inout TriangleStream<vertOut> stream) {
	// float3 v1 = i[0].vertex - i[1].vertex;
	// float3 v2 = i[0].vertex - i[2].vertex;
	// float3 v3 = i[1].vertex - i[2].vertex;

	// float3 norm = normalize(cross(v1, v2));
	// i[0].normal = (norm + i[0].normal)/2.0;
	
	// float3 norm2 = normalize(cross(v1, v3));
	// i[1].normal = (norm2 + i[1].normal)/2.0;

	// float3 norm3 = normalize(cross(v2, v3));
	// i[2].normal = (norm3 + i[2].normal)/2.0;

    stream.Append(i[0]);
	stream.Append(i[1]);
	stream.Append(i[2]);
}

#endif