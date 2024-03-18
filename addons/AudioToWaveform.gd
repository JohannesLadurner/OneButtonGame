extends Node

class_name AudioToWaveform

const MAX_FREQUENCY: float = 3000.0 # Maximum frequency captured
const SAMPLING_RATE = 2.0*MAX_FREQUENCY

static func generate(stream: AudioStreamWAV, points_per_second: int = 100, max_height: int = 500):
	if not stream or points_per_second <= 0 or max_height <= 0:
		return
	
	if stream.format == AudioStreamWAV.FORMAT_IMA_ADPCM:
		return # not supported
	
	var data = stream.data
	var data_size = data.size()
	var is_16bit = (stream.format == AudioStreamWAV.FORMAT_16_BITS)
	var is_stereo = stream.stereo
	
	# For display reasons, lower frequencies than the sampling rate might suffice. 
	# According to the gentlemen of noble steem known as Nyquist and Shannon, 
	# we can sample at SAMPLING_RATE
	var sample_interval = 1
	if stream.mix_rate > SAMPLING_RATE:
		sample_interval = int(round(stream.mix_rate / SAMPLING_RATE))
	if is_16bit:
		sample_interval *= 2
	if is_stereo:
		sample_interval *= 2
	
	var reduced_data = PackedByteArray()
	# We use floor(), not round(), because extra elements in the end of data
	# before next sampling interval are discarded
	var reduced_data_size = int(floor( data_size / float(sample_interval) ))
	reduced_data.resize(reduced_data_size)
	
	# For drawing a preview, we use only one byte left channel per sample
	# PCM16 is little endian, so MSB is index 1, not 0
	# reduced_data will contain only that one byte per sample
	var sample_in_i := 1 if is_16bit else 0
	var sample_out_i := 0
	while (sample_in_i < data_size) and (sample_out_i < reduced_data_size):
		reduced_data[sample_out_i] = data[sample_in_i]
		sample_in_i += sample_interval
		sample_out_i += 1
	
	# From now on we work only with reduced_data 
	var samples_per_pixel = ceil(reduced_data_size / float(stream.get_length() * points_per_second))
	
	var height_factor = float(max_height) / 256.0
	var sample_i = 0
	var final_sample_i = (reduced_data_size - samples_per_pixel)
	var data_heights = []
	var index = 0
	while sample_i < final_sample_i:
		var min_val := 128
		var max_val := 128
		for block_i in range(samples_per_pixel):
			var sample_val = reduced_data[sample_i]
			# Convert signed bytes to unsigned bytes
			sample_val += 128
			if sample_val >= 256:
				sample_val -= 256
			
			# Get minmax
			if sample_val < min_val:
				min_val = sample_val
			if sample_val > max_val:
				max_val = sample_val
		
			sample_i += 1
		
		var height1 = int(clamp(
			floor(max_height - (min_val*height_factor)),
			0, max_height-1
		))
		var height2 = int(clamp(
			floor(max_height - (max_val*height_factor)),
			0, max_height-1
		))
		data_heights.push_back(abs(height1 - height2))
		if index >= 2:
			data_heights[index-1] = floor((data_heights[index-2] + data_heights[index])/2)
		index += 1
		
	return data_heights
