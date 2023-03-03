def block_encoder(data_in):
    """Block encoder for a simple block code"""
    encoded_data = [data_in[i] ^ data_in[i+1] for i in range(len(data_in)-1)]
    encoded_data.append(data_in[-1])
    return encoded_data


def block_decoder(received_data):
    """Block decoder for a simple block code"""
    decoded_data = [received_data[0]]
    for i in range(len(received_data)-1):
        decoded_data.append(received_data[i] ^ decoded_data[i])
    return decoded_data
