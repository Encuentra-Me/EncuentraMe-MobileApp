/* Amplify Params - DO NOT EDIT
	ENV
	REGION
	STORAGE_ENCUENTRAMESTORAGE_BUCKETNAME
Amplify Params - DO NOT EDIT */

const AWS = require('aws-sdk');
// Creamos el cliente de Rekognition
const rek = new AWS.Rekognition();

/**
 * @type {import('@types/aws-lambda').APIGatewayProxyHandler}
 */
exports.handler = async (event) => {
  try {
    console.log('Evento entrante:', JSON.stringify(event));

    // Parseamos el body
    const { bucket, key, collectionId } = JSON.parse(event.body);

    // Llamada a Rekognition
    const resp = await rek.searchFacesByImage({
      CollectionId: collectionId,
      Image: {
        S3Object: { Bucket: bucket, Name: key }
      },
      FaceMatchThreshold: 70,
      MaxFaces: 20
    }).promise();

    // Construimos la lista de matches
    const matches = (resp.FaceMatches || []).map(m => ({
      faceId:         m.Face.FaceId,
      externalImageId: m.Face.ExternalImageId,
      similarity:     m.Similarity
    }));

    return {
      statusCode: 200,
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ matches })
    };

  } catch (error) {
    console.error('Error en Lambda:', error);
    return {
      statusCode: 500,
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ message: error.message })
    };
  }
};