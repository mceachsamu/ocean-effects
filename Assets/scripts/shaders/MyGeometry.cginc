#if !defined(FLAT_WIREFRAME_INCLUDED)
#define FLAT_WIREFRAME_INCLUDED

[maxvertexcount(3)]
void MyGeometryProgram (triangle vertOut i[3], inout TriangleStream<vertOut> stream) {
    stream.Append(i[0]);
	stream.Append(i[1]);
	stream.Append(i[2]);
}

#endif