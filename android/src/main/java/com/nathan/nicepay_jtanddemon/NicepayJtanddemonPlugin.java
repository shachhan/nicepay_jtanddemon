package com.nathan.nicepay_jtanddemon;

import android.content.Context;
import android.content.ContextWrapper;
import android.util.Log;
import android.os.Message;
import android.os.Bundle;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import net.jt.pos.utils.StringUtil;
import net.jt.pos.data.Signature;
import net.jt.pos.data.approval.CreditApproval;
import net.jt.pos.data.code.RequestCode;
import net.jt.pos.data.code.ApprovalCode;

import net.jt.pos.sdk.JTNetPosManager;
import net.jt.pos.sdk.JTNetLog;

import java.util.Map;
import java.util.Objects;


/** NicepayJtanddemonPlugin */
public class NicepayJtanddemonPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private static final String TAG = "NicepayJtanddemonPlugin";
  private Context context;
  private MethodChannel channel;
  private EventChannel eventChannel;

  private JTNetPosManager.RequestCallback requestCallback;
  private String resData = null;
  private static final String STREAM = "nicepay_jtanddemon/response";
  private static final String METHOD = "nicepay_jtanddemon/method";
  private EventChannel.EventSink eventSink;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "nicepay_jtanddemon/method");
    channel.setMethodCallHandler(this);
    context = flutterPluginBinding.getApplicationContext();

    eventChannel = new EventChannel(flutterPluginBinding.getBinaryMessenger(), STREAM);
    eventChannel.setStreamHandler(
        new EventChannel.StreamHandler() {
            @Override
            public void onListen(Object arguments, EventChannel.EventSink events) {
                eventSink = events;
            }

            @Override
            public void onCancel(Object arguments) {
                eventSink = null;
            }
        }
    );
  }

//  @Override
//  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
//    if (call.method.equals("getPlatformVersion")) {
//      result.success("Android " + android.os.Build.VERSION.RELEASE);
//    } else {
//      result.notImplemented();
//    }
//  }

  // nicepay_jtanddemon plugin
  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    switch (call.method) {
        case "init":
            JTNetLog.setContext(context);
            initJTNetPM();
            initJTNetPMCB();
            result.success(true);
            break;
        case "keyChange":
            result.success(true);
            break;
        case "creditApproval":
            Map<String, String> data = (Map<String, String>) call.arguments;
            Log.e(TAG, "data is : " + data);
            byte[] dataBytes = createCreditArr(ApprovalCode.CREDIT_START, data);
            JTNetPosManager.getInstance().jtdmProcess(6, dataBytes, requestCallback);
            result.success(true);
            break;
        case "creditCancel":
            Map<String, String> dataCancel = (Map<String, String>) call.arguments;
            Log.e(TAG, "data is : " + dataCancel);
            byte[] dataCancelBytes = createCreditArr(ApprovalCode.CREDIT_CANCEL, dataCancel);
            JTNetPosManager.getInstance().jtdmProcess(7, dataCancelBytes, requestCallback);
            result.success(true);
            break;
        default:
            result.notImplemented();
            break;
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
    eventChannel.setStreamHandler(null);
  }

  void initJTNetPM() {
      JTNetPosManager.init(context);
  }

  void initJTNetPMCB() {
    requestCallback = new JTNetPosManager.RequestCallback() {
        @Override
        public void onResponse(Message msg) {
          byte[] response = msg.getData().getByteArray("RESPONSE_MSG");

          if (response != null) {
//            Log.e(TAG, "response is : " + response);
            resData = StringUtil.byteArrayToString(response);
          }

          if (resData != null) {
            eventSink.success(resData);
          } else {
            eventSink.error("error", "error", "error");
          }
        }
    };
  }

  private byte[] getOrgTradeDate(boolean isCancel, Map<String, String> data) {
        return StringUtil.getRPadSpace(6,
                isCancel ? data.get("originalTradeDate") : "").getBytes();
  }

  private byte[] getOrgApprovalNo(boolean isCancel, Map<String, String> data) {
        return StringUtil.getRPadSpace(12,
                isCancel ? data.get("originalApprovalNo") : "").getBytes();
  }

  private byte[] getOrgTradeNo(boolean isCancel, Map<String, String> data) {
        return StringUtil.getRPadSpace(12,
                isCancel ? data.get("originalTradeNo") : "").getBytes();
  }

  private byte[] createCreditArr(ApprovalCode approvalCode, Map<String, String> data) {
        byte[] code = approvalCode.getCode().getBytes();
        boolean isCancel = approvalCode == ApprovalCode.CREDIT_CANCEL;

        // todo: unionpay check
        //        if (isUnionPay()) {
        //            code[3] = HexCode.UNION;
        //        }
        return new CreditApproval(
                code,
                StringUtil.getRPadSpace(10, data.get("deviceId")).getBytes(),   // deviceId : input from Flutter
                StringUtil.getRPadSpace(1, "").getBytes(),  // wcc : only one option defined
                StringUtil.getRPadSpace(100, "").getBytes(),    // track2 : only card slash defined
                data.get("installment").getBytes(),     // installment : input from Flutter
                StringUtil.getLPadZero(9, data.get("amount")).getBytes(),   // amount : input from Flutter
                StringUtil.getLPadZero(9, data.get("tax")).getBytes(),   // tax : input from Flutter
                StringUtil.getLPadZero(9, data.get("tip")).getBytes(),   // tip : input from Flutter
                getOrgTradeDate(isCancel, data),           // originalTradeDate : input from Flutter
                getOrgApprovalNo(isCancel, data),          // originalApprovalNo : input from Flutter
                getOrgTradeNo(isCancel, data),             // originalTradeNo : input from Flutter
                Signature.AUTO.getCode().getBytes()             // signature : judge by demon
        ).create();
    }
}